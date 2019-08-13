Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9356C8C466
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 00:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfHMWlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 18:41:20 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:37673 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbfHMWlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 18:41:19 -0400
Received: by mail-qk1-f171.google.com with SMTP id s14so10643384qkm.4
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 15:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Fio6CIRRv6Ey5rEkM2wXxRey3ugkCaHpzkGWtAUTUsg=;
        b=S9G6gW9uF5bgjFDfvyH7AEBBOPikSMBAliAGxJfjLtK1W3xfzYPYxNAzqFz+KBVKMA
         zeFC0W64gMDJWxB1MyZ+NQODA4m/RHOjy2rLLAB1XfBxfiygQmQ5orxIyI+EW4ZCxQup
         5ojFtngxRJiL6tqzqOLTQUxXmxvYQDtgb0pteY3hmrwdHHG26y+/ABTIltS7DMVZ2Omg
         7X7kNTVsMxPsK3Ods9UY8y3Td8nH+wEOoVEZsSqo5vSMcC6QQXDGHnekMqqMGrRlTI3n
         h/3JrI8wEkeUtJooXv1SFM1gih11LK3kqWUSPwZmIFztPBv2SVxniI/t8bg5vEG9MZpY
         6jkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Fio6CIRRv6Ey5rEkM2wXxRey3ugkCaHpzkGWtAUTUsg=;
        b=rfh+bTujdPPI9zyLRZS6kMYtpXx5XAFr/KxBpY0wXHOp2kn5A7d0jyMpNZrQ47Wm0N
         DGOjhCiiAfWgHyvbnI11F9OtlijqnrVhs9My+1uaP9A1tWATMwjkpp+d5Ec0+kICjGOL
         cERIUiKwgxR6IdREVTLk/wTUngz4yr7qJsd9tBAkku+Gur4pyM7gTs68m5T11eRbF4Yj
         3QAtqJojqZ1gle4MbS9kFdO207cNj11Xfa+3ugwj8wm4N1sfZjqbdYJNLr7YQJkDqHYm
         DuUIrCEJU0xEpnVgABZmCAZU+IrytrmTjEzyeI+3kysFKF0F0cUnoXJkaf9dIReAJeaX
         AFWg==
X-Gm-Message-State: APjAAAVXMCvX0HwCvw0NyrXJAp3C5sYg+/+j69MtBjL5DypiMf3faFkL
        pJCPH0R0w54DzD+91FohFu2b+w==
X-Google-Smtp-Source: APXvYqyFxgl6+Z7arrgkzp4phfVWU5B8eBSCGM0cdi82IJgzhXy+4o2sE9KLFlPeC/yZFc0qGzFAuw==
X-Received: by 2002:a37:a9c6:: with SMTP id s189mr13137188qke.191.1565736078684;
        Tue, 13 Aug 2019 15:41:18 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 131sm50464776qkn.7.2019.08.13.15.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 15:41:18 -0700 (PDT)
Date:   Tue, 13 Aug 2019 15:41:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next] selftests: netdevsim: add devlink params tests
Message-ID: <20190813154108.30509472@cakuba.netronome.com>
In-Reply-To: <20190813130446.25712-1-jiri@resnulli.us>
References: <20190813130446.25712-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 15:04:46 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
>=20
> Test recently added netdevsim devlink param implementation.
>=20
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Thanks for the test, but it doesn't pass here:

TEST: fw flash test                                                 [ OK ]
TEST: params test                                                   [FAIL]
	Failed to get test1 param value

> diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/t=
ools/testing/selftests/drivers/net/netdevsim/devlink.sh
> index 9d8baf5d14b3..858ebdc8d8a3 100755
> --- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
> +++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
> @@ -3,7 +3,7 @@
> =20
>  lib_dir=3D$(dirname $0)/../../../net/forwarding
> =20
> -ALL_TESTS=3D"fw_flash_test"
> +ALL_TESTS=3D"fw_flash_test params_test"
>  NUM_NETIFS=3D0
>  source $lib_dir/lib.sh
> =20
> @@ -30,6 +30,66 @@ fw_flash_test()
>  	log_test "fw flash test"
>  }
> =20
> +param_get()
> +{
> +	local name=3D$1
> +
> +	devlink dev param show $DL_HANDLE name $name -j | \
> +		jq -e -r '.[][][].values[] | select(.cmode =3D=3D "driverinit").value'

                   ^^

The -e makes jq set exit code to 1 when test1 param is false.

Quoting the man page:

       =C2=B7   -e / --exit-status:

           Sets the exit status of jq to 0 if the last output values
           was neither false nor null, 1 if the last output value was
           either false or  null,  or  4  if  no valid  result  was
           ever produced. Normally jq exits with 2 if there was any
           usage problem or system error, 3 if there was a jq program
           compile error, or 0 if the jq program ran.

Without the -e all is well:

# ./devlink.sh=20
TEST: fw flash test                                                 [ OK ]
TEST: params test                                                   [ OK ]

> +}
> +
