Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9AF33E983
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 07:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhCQGHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 02:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhCQGH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 02:07:29 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903C5C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 23:07:29 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id 30so259805ple.4
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 23:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4kFA8SdhluxrlmPQSi+Pg1WWdZ0c8aKVk9KSvVcgJUY=;
        b=o67jLgs5AxxQngXD6UplasObIGMN8mwH1WjqBqx77XwrL5n4I/gOOynriRy4yYHF61
         hF6HJgqUa8qXwAHhBq+66x5XP9BcsNczOYbV3CeZixk1pnaYQLmcolNIVDdbgBQwDkJN
         XV62SnG1di5GUR6ybjy6IrAn5B5ZPbhkF44CvqZD5uiWmSmJjCywdqBUawFFycFmXCh2
         OKQj8fcYPOPi3enocQC+ui84LxUMIvGJktdgZ6zBBnt5tg2pVM0A9fNZX8+so8ZCJ6sC
         YDC5hGekID8+G925UVHwsTJ9l9SzkD/RLDDIPg4yUPJVy+UUxPLrlVxKsp27gYLCzM7u
         RPsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4kFA8SdhluxrlmPQSi+Pg1WWdZ0c8aKVk9KSvVcgJUY=;
        b=tIMj5VxDat5qeg3S/ZnZRcllP3z0g/dapLm7h24dN7gFLPEnXmPhOLIZM2TDHcM38l
         nuhFX0C+1Enu+L49U9xkfgDpRs7myElBfvSTKQ129uHMa4VaCygArQyXmy5JS7qCnIkr
         hMMieESxKQ+T2NdzN2K2ccgBRnMce0Fz29WVFDUdDb8CbqIfhUcgx3yby2gUA15BDqE2
         zfkRh+PzVrTo61L0U7CI8O0b71jijWjxstJzrfQ7SCjl1disabWkVgfO2AsCbctk0uHQ
         12jJtLESLM8wTaAindgDxOAWbvCSB0EQYAQfdXGLzMvOPzXnUwZgcierRC2FfnYsCuo+
         bu4w==
X-Gm-Message-State: AOAM533Ey+HfJwjaF1eePTZSn7XXiBL6C1gYyph3gjS/rV88t/9UxpQJ
        M1o0niFT59IsqilUmMxYvMKosQ==
X-Google-Smtp-Source: ABdhPJx0WU0CkohgFRZW+5aOXOTtfXhFfPrFLfIQIQm01sV3Nq5eIidi9jeySR7XyiTpV+GqZ/pzqA==
X-Received: by 2002:a17:90a:9a91:: with SMTP id e17mr2799579pjp.218.1615961249084;
        Tue, 16 Mar 2021 23:07:29 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id 14sm18431034pfo.141.2021.03.16.23.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 23:07:28 -0700 (PDT)
Date:   Tue, 16 Mar 2021 23:07:20 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "B.Arenfeld" <b.arenfeld@arcor.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] Fix error message generated in routel script when have
 'multicase' in routing list
Message-ID: <20210316230720.7cdd0818@hermes.local>
In-Reply-To: <fe0c34409428f100fb2e602e021062b8c4df4b6b.camel@arcor.de>
References: <fe0c34409428f100fb2e602e021062b8c4df4b6b.camel@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 09:30:07 +0100
"B.Arenfeld" <b.arenfeld@arcor.de> wrote:

> Hello :-)
>=20
> I'm on an machine with Manjaro Linux.=C2=A0
> I get some error messages from shift command in the routel script:
> /usr/bin/routel: Zeile 48: shift: shift count out of range
>=20
> Reason are lines from "ip route list table 0" starting with word "multica=
st" :
> =20
> multicast ff00::/8 dev enp2s0 table local proto kernel metric 256 pref me=
dium
>=20
> I added the "multicast" word in routel script and everything is fine ;-)
>=20
> Greetings
>=20
> Burkhard Arenfeld
>=20
>=20
> Signed-off-by: Burkhard Arenfeld <b.arenfeld@arcor.de>
>=20
> --- routel.orig	2021-03-15 08:23:24.706677247 +0100
> +++ routel	2021-03-15 08:23:20.293589911 +0100
> @@ -25,7 +25,7 @@ ip route list table "$@" |
>      src=3D""
>      table=3D""
>      case $network in
> -       broadcast|local|unreachable) via=3D$network
> +       broadcast|local|multicast|unreachable) via=3D$network
>            network=3D$1
>            shift
>            ;;
>=20
>=20

There are several patches which make it impossible to apply.

Serious: the patch doesn't apply the current version of ip/routel in git
has the same line already there? Not sure where you found the original but
the version in git was imported back in 2015 (from Bitkeeper) and already
has the same line.  Did you get this from some vendor supplied out of date
distro?

Minor: the patch was not based at the normal place in the directory
tree. The standard practice is to do this at directory of the source tree.
In this case it would be in the iproute2 source directory. In that directory
the routel script is in ip sub directory.

Trivial: checkpatch whines that the name in From and Signed-off-by aren't
exact match. But that is just noise, and it looks ok.

Please compare with current iproute2 in git and see if your patch was backw=
ards?
