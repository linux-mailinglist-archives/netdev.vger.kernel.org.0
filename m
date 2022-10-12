Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90195FC460
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 13:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJLLjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 07:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiJLLjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 07:39:47 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851D865D8
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 04:39:44 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id pq16so15055309pjb.2
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 04:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xNs4i0dqw7zeztwTnDI2EfwxMIuBEVNEXe4DEXAyi5s=;
        b=BmkZEOkvN3x480zQW2M6uw5AtC5o+dWJA5pMGZC7IuMwqOKXBWfd11cprsdmIrwL8m
         rkKZZLsEaAL7M1f+m4PwJtuRXW5g0+y8BPEuo9gQtNUvVvpWR4H8thkKwhyhmxY73v+Z
         7vkB2ocMz9nfbUlYoSfZinTc8jAK3nZrnW25DXN2hd5HPWj7e2p7QBd8mDagZRD/FtDx
         HDyhHsSzQAr2niR9vVKwLSRZVcdVuiIi5InIE/WmOtwUDsUMOo1FRTonxMvaPhPGTKDA
         PKuTJKsBsDzwuUmQ3PnSsWuwVB5WLhGcRQZaqKNHbYgLrx1KbuCIM2Jf5L/51HjQznL/
         7fmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xNs4i0dqw7zeztwTnDI2EfwxMIuBEVNEXe4DEXAyi5s=;
        b=YWuCk1JGiHdk4nW4qSDEdYpuo6v+5EEFw5TBM13QpOFVsREK4pStpnTQ31i5u8/cKF
         guM7N1W/elyjYxGBZZE0DggYZY1fI0nsHqubZBGbTUl1sU9UG8iqK/e1KnQq/lnt+RTI
         jdoVzZUA+6AyISo4wdHR3UqaqKtk6QXvASxvRkzPkaBvxiM/NR7BRvqnNz0AtENpqrM5
         Ukru4ZJnI0vX+mDKV7We6E6wt/Bp4CacZ5VKgPOE4Rel197FWI4PrK+SVqtIvxW0yTd1
         U4ccJiLYT630eEnDMfe5GgOuW920PoRkbbEcvabdG8C4qPcTu0UVmZEy3f1ndmmf051L
         7MPg==
X-Gm-Message-State: ACrzQf3XNw1v38OdD+Bb9w9O3ECpCbq5d1x5G7jX0PzSenF8BiQjuuPs
        CPBsyCnb8OxpJSihbDe3NmLSvEmqKIOqTb6z6ro=
X-Google-Smtp-Source: AMsMyM5J7Zmzif7aPrkStHbVDwRsqRsBXXcVkgAQj/6cSI6aN+yFZvYCqKKV6L6ZSgNNFovp02/cvFdCo9T5J+ySCKc=
X-Received: by 2002:a17:902:d4c6:b0:180:bdd5:1275 with SMTP id
 o6-20020a170902d4c600b00180bdd51275mr23708900plg.121.1665574784073; Wed, 12
 Oct 2022 04:39:44 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkaylama@gmail.com
Sender: aessoyomewesolim@gmail.com
Received: by 2002:a05:6a10:280a:b0:2fc:cfdc:b815 with HTTP; Wed, 12 Oct 2022
 04:39:43 -0700 (PDT)
From:   sgtkaylama <sgtkaylama@gmail.com>
Date:   Wed, 12 Oct 2022 11:39:43 +0000
X-Google-Sender-Auth: aPJEKZRpAjGnabKxk-u9MAOYUoY
Message-ID: <CAPXm1KBt=xykYgXrzfOeznSirwg_CErvOB=29iuex4gA=VE7EQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TmVkb3N0YWwganNlbSB2YcWhaSBvZHBvdsSbxI8gbmEgbcOpIHBvc2xlZG7DrSBwxZllZGNob3rD
rSB6cHLDoXZ5DQo=
