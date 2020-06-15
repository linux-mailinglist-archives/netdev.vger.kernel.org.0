Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03B51F8C59
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 04:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgFOCv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 22:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727971AbgFOCv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 22:51:59 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50080C061A0E;
        Sun, 14 Jun 2020 19:51:59 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49lbT70KGkz9sQx;
        Mon, 15 Jun 2020 12:51:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1592189516; bh=DV1gl6QIOTIchXrghVyp4BL/TlLJWU8yAd0/vf0yI5w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WXXisGc9SKJvW7CC/0/ckfQWJXkplKNYxTwq5GLuxiUnk4bQoKGk/4PtAx/xm7FH+
         VRUFWJR0zdq+F1veYaGM+hik9Yek4ITMWCJd1NqKx7SJ+YWbu2Uj5zRlsio9CSgqnG
         VrfkcHrN0QDCRkye7QvSfA6mYeQGKmO+kDJo7n8SUTWUYDUziMIjcRXo+MdedAt5wa
         ZwEU/KtPr5I8hPpAZ6nJfflDL8qo8FDgqCnq+iuIpMdFmMaGqhGG+OgOMf+gt3Cg/X
         DBbLiJ4CMYX7yeBlpyhFBqHZH5pSUflkKrb2iLuQXRFsWgt2SpUxmRSHhPt2nS0haY
         xHh/fUv2mjVFQ==
Message-ID: <34af26149a27a96d6bbdd1615771691cb49f4fcd.camel@ozlabs.org>
Subject: Re: [RFC PATCH] net: usb: ax88179_178a: fix packet alignment padding
From:   Jeremy Kerr <jk@ozlabs.org>
To:     louis@asix.com.tw, "'ASIX_Allan [Office]'" <allan@asix.com.tw>,
        'Freddy Xin' <freddy@asix.com.tw>
Cc:     'Peter Fink' <pfink@christ-es.de>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Date:   Mon, 15 Jun 2020 10:51:54 +0800
In-Reply-To: <000801d6406f$757d45e0$6077d1a0$@asix.com.tw>
References: <20200527060334.19441-1-jk@ozlabs.org>
         <b9e1db7761761e321b23bd0d22ab981cbd5d6abe.camel@ozlabs.org>
         <000601d638a2$317f44d0$947dce70$@asix.com.tw>
         <000801d6406f$757d45e0$6077d1a0$@asix.com.tw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Louis,

> Thanks for the correction.
> Indeed, the hardware adds two bytes dummy data at beginning of
> Ethernet packet to make IP header aligned. 
> The original patch made by Freddy contains the length of dummy
> header. 

OK, thanks for checking. I understand this to mean that the fix is
correct, so I'll send it upstream without the RFC tag.

Regards,


Jeremy


