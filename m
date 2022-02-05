Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882224AA607
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 03:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379012AbiBECuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 21:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiBECuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 21:50:40 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641AEC061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 18:50:39 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id r27so10729289oiw.4
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 18:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=gdeKxL/Zv2ssZKEkXAT4T4+kmzHUOZ6HiSbC2qBa2Zo=;
        b=jSKVnsLK0ShP+oB5oRWMtGewD1z94a5ZqvcmovyIgsI93pnnTN4G/69qKoStErmB2Q
         LsQnlCFjvEui1IsY70DXBrnuRzZm5gMtERZ/3YBJaw6gLjl3zqNOLZEWuJTIUnvq7dHn
         Fn5LsOI6WozYi3WCYfAGPv1H0+n3jqWHvQijC8jGXnjWbnupxPyi5sgDcY1wh1k1+sml
         bShwTNWVBCxvKlrRnclKJHd5WXVV7J8YwCgllXwk+o9QNCIwwdZsziq+br8LtC1eI59n
         kuql/BET6QqQW/gCK7G8We477MMCzx507bHSmryC6UU6XLvrpiz2sBZvVcXTPodxkuwz
         uImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=gdeKxL/Zv2ssZKEkXAT4T4+kmzHUOZ6HiSbC2qBa2Zo=;
        b=Ian/HMdhREJRR50CTMRZgPAzbodTbY6g0Ga5yRRrY0VWNHYPAjf3B/fE2SqZcCrLqv
         DOJDk4DoL6qJUwmRp4y/mGeBqhYG6YlGiygWxKJnN+8NQ/qhlZGuDieQhTm6hNsTsKJc
         f2n0hk+fpfvqPhVzqCea01lN/+7Z14XA1czQXC9BAOyDecKLTQjj/lgcQTPdWpYyJ1fY
         DdnnIjLR1u4IFfbPvd6b/vadzVpDF1zvYbIc7dsZtxcjDnwZ0s0qQ2Y1u+Uk1VIz2gvX
         OaN95x0B9FF1ZgNpzBisq1k/yfJfUNZoN8LE7c7XozQxePUJiZwVHtgaZintfAzIIJ4l
         nmxQ==
X-Gm-Message-State: AOAM533CHsEoRDf2EL4J0kc9gonvziQubRr65h5pI7sUHdlZ01v0mdao
        g3tO8nqINRh1Rk2Mv288c1bKZKmtt8TzpzFiU+o=
X-Google-Smtp-Source: ABdhPJyruoXTfcoZtTlQJHxD17qTZOm3p0r7Kln/pOkf5tbytKvSpRVv/5eVn0ZMYD/WPats96s9b9Z3Wny7GH70OwY=
X-Received: by 2002:aca:aa86:: with SMTP id t128mr882438oie.169.1644029438730;
 Fri, 04 Feb 2022 18:50:38 -0800 (PST)
MIME-Version: 1.0
Sender: akouhgloria2017@gmail.com
Received: by 2002:a8a:d55:0:0:0:0:0 with HTTP; Fri, 4 Feb 2022 18:50:38 -0800 (PST)
From:   Maya Leo <mayaleo0077@gmail.com>
Date:   Sat, 5 Feb 2022 02:50:38 +0000
X-Google-Sender-Auth: VMLC3Wq6rm-Gy4TLjKhK6d0atz0
Message-ID: <CAMndNL2AhKqzomOa-0uergxsv5d88ErPF8Ahy6PUskynHfoyjg@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear ,
Nice to meet you
My name is Maya Leo i will be glad if we get to know each other  and
share pictures thank you.
