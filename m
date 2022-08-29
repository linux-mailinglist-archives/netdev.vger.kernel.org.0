Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51255A50AB
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 17:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiH2Pu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 11:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiH2Pu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 11:50:56 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C426F87093
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 08:50:54 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bs25so10751548wrb.2
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 08:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=tlN+WWCM6hnCn3r5d52raD5+g7zBw+Q/FQYK/mGj7Wo=;
        b=QmUJGa2HuTnsDAL8yxNTmwuv4SOfaYDJre0OfIDOe9xPbSEpB0OKk44GV7Tk3Y0CNm
         0cf6I1rg6keiPtZn/TiagQHw9lcuByBf9nWYB9+oz2uSee2ehzuUmyqdYfl972tddjAB
         Cv62ghM85+MJI8V3DDORbiCErvv07PDT72uiyl/K02CdPt1How0Vrc41uxPVIpltFTxk
         54wxIdTYxrmGbcXIHSBYfqWGwDAhL0NQjM0gP0Kf3L5i/RLiJ4/TzHDkmfcAeSevkUuB
         xeWn5AV6WfK/eMV8pgfsXIlAyApxUMHOuKSsta7NB6N3hBP5CbnjTYKNuUPfpupMVlt7
         SiUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=tlN+WWCM6hnCn3r5d52raD5+g7zBw+Q/FQYK/mGj7Wo=;
        b=uwmXg4DBtjBzUv7CK80iMjSAh+LnM5u2bDjlk+SacP0okKhRAj/AwS2HhjU9n3zaEb
         LJuQXLlYrCqj70Lj689ZBduHLjLtuP3vuOahJBk2AdkYxCzpdFKdZF5RhxfCW3WrvYJV
         8z9eDyxBzR5wSttvlOe5Khv7sr8u4M0oufduEVDyUDoKOVrXY5bb2FCGiYwLvYHLXbEd
         IwKxacl5r5XmvTJft6c8hhIGuVkEq+ianQNLmnDE55aDM0vTvySf0Hsqft3y4aezzl6T
         ut6kVu2uIdUMmZvuEEV/4fx0LaGIdNqmPzxxBU+BgkJS00N/qQzYo3ISL1LBISwxsrYX
         P/Rg==
X-Gm-Message-State: ACgBeo0Pz8aCS1+xlKeN5yr8jY0P1QxQtsXXwTwEdYEW27EeFnAqYpCl
        VOrrL8nw+TO5FanW7TkcHY+SVaNx+NJslGaKMJs=
X-Google-Smtp-Source: AA6agR6hbnoGMrAnm6pkdovoN1xIfP8PR54d/kLqdVOCNcoRMSpUlWpVJ7BnK0XTYs4kfVGCxZ5wzd08M3gm92gzIds=
X-Received: by 2002:adf:f90d:0:b0:20c:de32:4d35 with SMTP id
 b13-20020adff90d000000b0020cde324d35mr6708462wrr.583.1661788253351; Mon, 29
 Aug 2022 08:50:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6020:9924:b0:204:566a:be31 with HTTP; Mon, 29 Aug 2022
 08:50:52 -0700 (PDT)
Reply-To: mr.ahodolevi@gmail.com
From:   George Levi <howen1791@gmail.com>
Date:   Mon, 29 Aug 2022 15:50:52 +0000
Message-ID: <CAL3=6ivpmo_Mz--P1ycoZ-Gmi8dvPbP_JZHZxv1zpHYrR01HOQ@mail.gmail.com>
Subject: Deposit
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:42d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [howen1791[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [howen1791[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.7 SCC_BODY_URI_ONLY No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear
I am contacting you to assist retrieve his huge deposit Mr. Alexander
left in the bank before its get confiscated by the bank. Get back to
me for more detail's
Barr.George Levi
