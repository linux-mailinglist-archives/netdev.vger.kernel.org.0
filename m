Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE0C51BFF
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfFXUIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 16:08:10 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45564 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfFXUII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 16:08:08 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so15870476qtr.12
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 13:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0iQ70DPQB0xAarJPI9ByeiNId5fZerRJ13Slws+p5JM=;
        b=NQexTrSzg+w3rbkiLnyem+5GSuGPmnN3YkU8s5MWyuPBQIlVesl41mwo1eyAb79KBG
         nvnBQ9Mac777JzV8y/PqUgJsSXWETDIwaVoHDkwsA/j0HRd2QSBgjb4UPG9vO5GqdjUo
         D48ZHDlF9rTX5scU9mTBhd9DK8CfIZbAGsXYGcWpI0QsaJszvMx2zcdX8MD3E0bz0tj4
         s/VI2ZC7q1OwqyW1lueHF/R2cglVkKFpOmZj3b7hgca1M3BRJwQDEGuMQpMfsAeC4pbT
         8LTtDPt6bbcRjirJ/DKCm0+ud8v/sI9z5eP8jcA5PgXblZ50bC4Gn2FWR64Kjrtj2j9w
         eH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0iQ70DPQB0xAarJPI9ByeiNId5fZerRJ13Slws+p5JM=;
        b=HLDoTck+jaD0IhTO/CIyptMWsVu/8s/j8eGQBuliVyOoQovnyPAweoKYvVtY/TTzeY
         KvDfSRvu3V9Rv954eliXZ/MKLC0NgZ/bdjNRAoyHt6aA6vCQsBruv5wJM5Indbj6pl6N
         0eYH8xMToYgu49YpIIMTzAJMjR4G7NtdPc7DI3X0ToQOx6SHTJWCoRCD2+tOmhPDcS1B
         M+Zcgc9jFWcAELmTbIIVUz3JAzsBSMAzIIoWLHwYA05J6CxI0HE5yUuxoO+J2vVUFXtH
         /Fv+uTdGLtniNUUrVTJ0khfZYpmfHl68aYh0JXViBKEXUaTePvub+S5JnQWHRylFgxP7
         rVbg==
X-Gm-Message-State: APjAAAW5zNuKbPg4vevcuVnlDUiTgwoOO/QjkP6j57TCSfgjKFbUlf2H
        RbYALs/jvHW4K+/O4aauTJrlOA==
X-Google-Smtp-Source: APXvYqx0ow7UKwfRtA0gBo2VQ54FGXkoa9fVTPXBgAbCCBYeEC2YdQceL7MdUv2H8PQkhZk/5Beiag==
X-Received: by 2002:a0c:b0e4:: with SMTP id p33mr49931228qvc.208.1561406887433;
        Mon, 24 Jun 2019 13:08:07 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s8sm5976950qkg.64.2019.06.24.13.08.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 13:08:07 -0700 (PDT)
Date:   Mon, 24 Jun 2019 13:07:59 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/18] ionic: Add basic framework for IONIC
 Network device driver
Message-ID: <20190624130759.3d413c26@cakuba.netronome.com>
In-Reply-To: <7f1fcda2-dce4-feb6-ec3a-c54bfb691e5d@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-2-snelson@pensando.io>
        <20190620212447.GJ31306@lunn.ch>
        <7f1fcda2-dce4-feb6-ec3a-c54bfb691e5d@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jun 2019 15:13:31 -0700, Shannon Nelson wrote:
> >> +#define DRV_VERSION		"0.11.0-k" =20
> > DRV_VERSION is pretty useless. What you really want to know is the
> > kernel git tree and commit. The big distributions might backport this
> > version of the driver back to the old kernel with a million
> > patches. At which point 0.11.0-k tells you nothing much. =20
> Yes, any version numbering thing from the big distros is put into=20
> question, but I find this number useful to me for tracking what has been=
=20
> put into the upstream kernel.=C2=A0 This plus the full kernel version giv=
es=20
> me a pretty good idea of what I'm looking at.

Still, we strongly encourage ditching the driver version. =20
It encourages upstream first development model among other benefits.
