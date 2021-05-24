Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD5539058A
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 17:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbhEYPgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 11:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhEYPgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 11:36:23 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3F5C061574
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 08:34:52 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e22so7293720pgv.10
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 08:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HJuYnDvjBfQl3AUJGIQB3T/tZJHlIBS6XZtPsUMdOuM=;
        b=ABnfTojtLImpmT65uTwocGU4UQ03gLnRRdgoyzY5nOnfb1gS5biLmlcxpRwt2Apk+H
         XgVJe/LeE51sGH48A0wdfhKsYSzfFPuxf2kWUz3Bw2AKUNuCsg1cCnbB/kZX0stLpkXA
         ucMT60YyC+6RnAkYLF6Q60JaQ1iR+V/L28N5gQD2IQR7QGiW7e1N7sfts3Ie2Qim5dHk
         8N81hEbIOKAB9k3/NjbP86s2ewOBLk7HP+DkSPq9RsSgXrrg82zH3J4QpE3eKDjGVDK1
         +xkdtHK3lvMa1nbLldUej/BvYqswTf4wQyGARFxIkgnJY36eTFnf1xPuMlgIFuLTrfmY
         X5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HJuYnDvjBfQl3AUJGIQB3T/tZJHlIBS6XZtPsUMdOuM=;
        b=kjv7q6XNPnRSOLpMrbtj31iS6ZPiviKdTxMdd8DAvWRuPLxLmYiWlVkbxYWCwIjKaJ
         XgdmbWw7TYOFYthbxZlXdfqdHvWikdpnHMnTMVuarfqubBJEefC4l44yqhPGc++YzEeu
         xfNAY+lNWfZyOUiRRa+o3UChD6NPRMBrwtjpRXiGTXR3amNr8SileUX2QceNJiWfRgjk
         /9m24gLdD3eEfrgpz8fw0fqepeP2pNwVU2e3YlQybp5qGkfKOTkLFnlhQRZEeEMmHfrb
         xyxRFVc/M0EYug5MMlzArtOPcMqbUPhTrX0PP68ij4OfH3PD2adk5yznboIuzrJ3GIeP
         7ANQ==
X-Gm-Message-State: AOAM532f6zhj9VJ4kLpo9ebU7Gz8xM7he40TQfsuraskG+/J4Hlm4DA4
        BzdlcxG26HJ09x3ggc4pCWKifko3CNF+1w==
X-Google-Smtp-Source: ABdhPJwn+8GqsBZ9aGn0D4vPFA376p/gnv6k2EHcvKup/YaTzGts6UGweGySy2/xPDOYebtfgeeVWQ==
X-Received: by 2002:a62:5a46:0:b029:2d5:a67:1460 with SMTP id o67-20020a625a460000b02902d50a671460mr30503608pfb.75.1621956891936;
        Tue, 25 May 2021 08:34:51 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id y13sm14639890pgp.16.2021.05.25.08.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 08:34:51 -0700 (PDT)
Date:   Mon, 24 May 2021 14:36:20 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org
Subject: Re: Crosscompiling iproute2
Message-ID: <20210524143620.465dd25d@hermes.local>
In-Reply-To: <D24044ED-FAC6-4587-B157-A2082A502476@public-files.de>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
        <20210516141745.009403b7@hermes.local>
        <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57>
        <20210517123628.13624eeb@hermes.local>
        <D24044ED-FAC6-4587-B157-A2082A502476@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 May 2021 21:06:02 +0200
Frank Wunderlich <frank-w@public-files.de> wrote:

> Am 17. Mai 2021 21:36:28 MESZ schrieb Stephen Hemminger <stephen@networkplumber.org>:
> >On Mon, 17 May 2021 09:44:21 +0200
> >This works for me:
> >
> >make CC="$CC" LD="$LD" HOSTCC=gcc  
> 
> Hi,
> 
> Currently have an issue i guess from install. After compile i install into local directory,pack it and unpack on target system (/usr/local/sbin).tried
> 
> https://github.com/frank-w/iproute2/blob/main/crosscompile.sh#L17

> 
> Basic ip commands work,but if i try e.g. this
> 
> ip link add name lanbr0 type bridge vlan_filtering 1 vlan_default_pvid 500
> 
> I get this:
> 
> Garbage instead of arguments "vlan_filtering ...". Try "ip link help".
> 
> I guess ip tries to call bridge binary from wrong path (tried $PRFX/usr/local/bin).
> 
> regards Frank

No ip command does not call bridge.

More likely either your kernel is out of date with the ip command (ie new ip command is asking for
something kernel doesn't understand); or the iplink_bridge.c was not compiled as part of your compile;
or simple PATH issue
or your system is not handling dlopen(NULL) correctly.

What happens is that the "type" field in ip link triggers the code
to use dlopen as form of introspection (see get_link_kind)
