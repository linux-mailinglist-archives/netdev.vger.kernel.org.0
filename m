Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F53846082B
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 18:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345932AbhK1Ryl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 12:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358728AbhK1Rwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 12:52:40 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E5DC061758
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 09:49:24 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g14so62009815edb.8
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 09:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=f3uCMrV6scHGWJ2mCH8lNpSClJY3Qism+DzoxpUlQkk=;
        b=njE/BjN7nSlalwzk6jNH/qizCvKuUd4bRdnMYnheqKnGhKjyOSDCcePnahGlX/y1I9
         nPmH07R4ZblwhDUb6LuMNEKrP24hvq7YJGV8SlLybh+GGu7jaZQKbtyWRbv0zgIWFWT8
         Ry6u8vYI4F9dxH4Svx2WnHYhsDxHO7KUG8D7kC7xRx7mYuG03yJNPTE1OrKQHgZTNFAm
         0v35e/pcTgbY6YF1qt4ajVhTB1eHy3uujngIzvs2IJNL9L4ZZbnIw+xCH0SVacUgBkwu
         jGR08bXcnH3YRRZj3w2ehuMxrE32+YhPtf06V35ECwF8XN7MefCl/gqZtmEdtW/XxngR
         QRiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=f3uCMrV6scHGWJ2mCH8lNpSClJY3Qism+DzoxpUlQkk=;
        b=xBrTGy0pFtlZnJYyZefETXF635n+PK9Mil8btgpo0dVk2xl+pNqPcERY10N08TRSYV
         YAhUtamTy2JBeAYt6RgSBbi+eO9Fn2PCxXb3UHK2qUsttMSM49qxGRGF4/ZxG3c5BU66
         wC/5UCNkYDmlWTsL3DiFdodG+l/+W7vxT9XNUdD6a1oNDuvVX13Y+TsqMZ3sT/oBSKsJ
         94rio7iBmCcr5a/Jv4B0/SUWCK7pSsXDB025FbkONShvQcGSjsAGfjfWAJXJEOXfvEGw
         vl7/EtcnKZqL4+hCqF//hUdu/W5Vl50WLeou4o+HhLx6nMUcimnV3/2LZG7VC5+YJ/x/
         lsdA==
X-Gm-Message-State: AOAM532uY+5+e5SZEVpLaFTG7EkEplrf7v2SaWP81I/xJ3oOl3Wrola1
        XqM78nkZxRGXHB5uK/95SKb7HbxfQHCJHQV6hqY=
X-Google-Smtp-Source: ABdhPJxDZBegWXtaG9GVrW/chAAfkTEs6zTwBRyAAJwyVfIVCENSVMg9skJu1Sajj2p32Zkumsk0QiLTuV2jzJ/TQRc=
X-Received: by 2002:a05:6402:4249:: with SMTP id g9mr66838227edb.316.1638121762585;
 Sun, 28 Nov 2021 09:49:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:2d11:0:0:0:0 with HTTP; Sun, 28 Nov 2021 09:49:22
 -0800 (PST)
Reply-To: wwwheadofficet@gmail.com
From:   "wwwheadofficet@gmail.com" <infowunion2@gmail.com>
Date:   Sun, 28 Nov 2021 17:49:22 +0000
Message-ID: <CACRybBZaxUZKn51SYxDTjOkZtFxjO=LUNghYiMBBYYehbui7bw@mail.gmail.com>
Subject: wu
To:     infowunion2@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQoNCg0KLS0gDQog0JrQvtC90YLQsNC60YLQvdC+0LUg0LvQuNGG0L4g0L3QsNGI0LXQs9C+
INC+0YTQuNGB0LA6IDI1NTQgUm9hZCBPZiBLcGFsaW1lIEZhY2UgUGhhcm1hY3kgQmV0LA0K0JvQ
vtC80LUsINC30LDQu9C40LIuDQoNCtCt0YLQviDQtNC40YDQtdC60YLQvtGAINCx0LDQvdC60LAg
V1Ug0L/RgNC40L3QvtGB0LjRgiDQstCw0Lwg0YPQstC10LTQvtC80LvQtdC90LjQtSwg0YfRgtC+
INCc0LXQttC00YPQvdCw0YDQvtC00L3Ri9C5DQrQstCw0LvRjtGC0L3Ri9C5INGE0L7QvdC0ICjQ
nNCS0KQpINCy0YvQv9C70LDRgtC40Lsg0LLQsNC8INC60L7QvNC/0LXQvdGB0LDRhtC40Y4g0LIg
0YDQsNC30LzQtdGA0LUgODUwIDAwMCwwMA0K0LTQvtC70LvQsNGA0L7QsiDQt9CwINGC0L4sINGH
0YLQviDQvtC90Lgg0L3QsNGI0LvQuCDQstCw0Ygg0LDQtNGA0LXRgSDRjdC70LXQutGC0YDQvtC9
0L3QvtC5INC/0L7Rh9GC0Ysg0LIg0YHQv9C40YHQutC1DQrQttC10YDRgtCyINC80L7RiNC10L3Q
vdC40YfQtdGB0YLQstCwLiDQktGLINGF0L7RgtC40YLQtSDQv9C+0LvRg9GH0LjRgtGMINGN0YLQ
vtGCINGE0L7QvdC0INC40LvQuCDQvdC10YI/DQoNCtCc0Ysg0YEg0L3QtdGC0LXRgNC/0LXQvdC4
0LXQvCDQttC00LXQvCDQstCw0YjQtdCz0L4g0L7RgtCy0LXRgtCwLg0KDQrQotC+0L3QuCDQkNC7
0YzQsdC10YDRgg0K0JHQkNCd0JrQntCS0KHQmtCY0Jkg0JTQmNCg0JXQmtCi0J7QoA0KV2hhdHNB
cHAsICsyMjg5MzA4NTQ3OQ0K
