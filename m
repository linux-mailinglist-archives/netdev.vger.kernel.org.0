Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09221661A5D
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 23:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjAHWPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 17:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjAHWPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 17:15:00 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FDC2BDF
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 14:14:59 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id p12so3342978qkm.0
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 14:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/krrOzf32PMDRBi/P9qe9m671OONK8NSr+9AstJjJkE=;
        b=qKOG2AsFAp6YYKWcmtqzraUvJQtyMUULXlTVMAiS6i5AcLmv59JSk6GyNv6WwQm6gB
         dh2JQWLsHhbu/QHLFgzlxtNcN3/ZeqaLXofME8e1NkEXU5IX2OCW8Agufe9Vx4/3cW36
         uF0kB6PoTpihpf8Ir1jTk0SlcIFAOjZ2rDOtKdo5IvndFOTWcPlhOFL1mGdRTT5AeTwG
         gbAqIreI3larkd2pq4EXOwhuIDEsSFPQi/+pG5LoqTadigTEkqCr4I6moevOjP0X2PFb
         5SanrvoG+Qu2bhBWVa9QiEs7WsKBRm0TLRiMds+9cxKuwRrFrdavaqjCLsVE5//imYTD
         nXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/krrOzf32PMDRBi/P9qe9m671OONK8NSr+9AstJjJkE=;
        b=p/ST3yx19k9A21GCUBJlWYTZ3HbdN9aLGg3nMhM2mKROgdhX8S8SNl/BoLr/RY1R1F
         rPSB0PzaJ9QkviqnkGCo1sx+DopirmAx1bChGfOhqswHIV/VNrTsPzrc5LwdjR8poNX+
         4GZJrVI6/Flmx066On1pU3UcpqkWTKrUMn8BAfTAoLdqBXzL/T0GCZ+RRlzi7PyAb/lU
         NpMLJxpKaC+7qy8MnO8BKG6qN978uH2rOYs735eraPqRG20r36wb97bsOCWZjltdHvK5
         /EboLaVl9sB0Y0Ydhq7h1NB8aCK1Cdnd1AwXPGA8tPWgzCaugci9/tUqc+sA2RzQL0/7
         72ow==
X-Gm-Message-State: AFqh2koscnQWg2kSGWaJvUmoZCSBEctCyT97JZqAOuPdfwMkpvSJxgNg
        33QMblPvp5/PyP8p+sLmPKhKJXj9zhyv5XnJU1s=
X-Google-Smtp-Source: AMrXdXsfijDw4oi1S84ZlJZEIVLTUzJ5HfcJMWnGgRoBJOZewrYbUXalGAZ/CKzaL9U0vyjeeep9wbNNHuJ9THIJiKM=
X-Received: by 2002:a05:620a:20ca:b0:702:4c7d:815d with SMTP id
 f10-20020a05620a20ca00b007024c7d815dmr3969465qka.763.1673216097840; Sun, 08
 Jan 2023 14:14:57 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a0c:904f:0:b0:4c7:6925:71ab with HTTP; Sun, 8 Jan 2023
 14:14:57 -0800 (PST)
Reply-To: avamedicinemed3@gmail.com
From:   Dr Ava Smith <mrsmalingwansuzara00@gmail.com>
Date:   Sun, 8 Jan 2023 23:14:57 +0100
Message-ID: <CAGYVCFBWjQJKupntUQtOiyX3BHrc3EwB2ge1d=8E_TQj8BaDUA@mail.gmail.com>
Subject: From Dr Ava Smith in United States
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear
My name is Dr Ava Smith,a medical doctor from United States.
I have Dual citizenship which is English and French.
I will share pictures and more details about me as soon as i get
a response from you
Thanks
Ava
