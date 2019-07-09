Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1172563DE5
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 00:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGIWeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 18:34:01 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33257 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIWeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 18:34:01 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so530260iog.0
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 15:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0tiY/m/fRYsSbSFHC2I+k6M/rAWw98vTvhNrlzbmbtU=;
        b=GCMec1ByU/Wp2eZWwc+IUDJwvcOjdJ53k5gg4f5pdrUofaG+uS6DCBObDdgJLVRuuG
         ggd6gdk3sGKjCsiO6F2+t7+COIx9Us+8G2xlBymq+4/D+JSmRsSG6lba7GGEnSsiojR0
         AOBwJ8cCO93K9x6vmtyaGY34d8eaqiUGcxKQ3Yq/lVXu5InEEejgCTCWQUyNGdM18IjS
         dl5uL0Ai66wLDrX3wuCjNFOpg6kn9IOtOOpZ6dceP8KBhNjZay2It2MWUEwVDPZya9+g
         JEbufy0rC5HQ2/xw7sROXkvJ8EOM2guHXWI1SLNBNNjZDFxfSFic4qRIgCJFZQemyJSs
         Bvbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0tiY/m/fRYsSbSFHC2I+k6M/rAWw98vTvhNrlzbmbtU=;
        b=E+5XX1SJYqiryqU9ElXFlIXi/UM3xoNzswdsgXUwDnqC90ovi/Kv02BP8bgvmFzq/J
         qvLeEXLt9WpolESYIn2GOTGnQhPeOk3ejBMLOP+oFKcvz/D96lTZPjFMBR4HN+vtnsYi
         OHVJXtTWmVRN0w6RSaTDMDTRSNyK9ZHAAiaRN+h6NeiBBIUuwU7dXSQ8OegNSlxVoCEG
         tCPWGCkBDHIFVqISEGZl5CkVOXgP5gYMInaKNSLTmCO7AGg2admP5+LvWof/y3ztoAi0
         XW+w/6JAsm+1K0RZ3Q3wgjUoYwStzpOwU+l6E76oVTFWMbIHWuu9WkFtIvjBs0LDCfwJ
         4ADQ==
X-Gm-Message-State: APjAAAWpB64y5nQh5mgwlvsi8MuNIVPwgsvt2BfFIISh1L1tbsoxUhJo
        6FS3Z554OwT0KACwJ+YJP+NgjwmDlcQ=
X-Google-Smtp-Source: APXvYqwp6AC2ht2qOCPrzp/dk0KCV5FUUu1NbmfCpFvG8KFbK568bq/opLVn5y5cv8/n2kxrn3gwcQ==
X-Received: by 2002:a6b:730f:: with SMTP id e15mr27194292ioh.74.1562711640742;
        Tue, 09 Jul 2019 15:34:00 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:c0e1:11bc:b0c5:7f? ([2601:282:800:fd80:c0e1:11bc:b0c5:7f])
        by smtp.googlemail.com with ESMTPSA id v10sm98622iob.43.2019.07.09.15.33.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 15:33:59 -0700 (PDT)
Subject: Re: [PATCH net-next iproute2 v1] devlink: Show devlink port number
To:     Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jiri@mellanox.com, dsahern@kernel.org
References: <20190709163352.20371-1-parav@mellanox.com>
 <20190709172654.24057-1-parav@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <36e986db-77c2-f0b0-77ab-f0bc70eb8324@gmail.com>
Date:   Tue, 9 Jul 2019 16:33:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190709172654.24057-1-parav@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/19 11:26 AM, Parav Pandit wrote:
> Show devlink port number whenever kernel reports that attribute.
> 
> An example output for a physical port.
> $ devlink port show
> pci/0000:06:00.1/65535: type eth netdev eth1_p1 flavour physical port 1
> 
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
> Changelog:
> v0->v1:
>  - Declare and assign port_number as two different lines.
> ---
>  devlink/devlink.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

applied to iproute2-next. Thanks


