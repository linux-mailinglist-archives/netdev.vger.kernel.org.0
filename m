Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1975EF3A0
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 12:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiI2Kkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 06:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiI2Kkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 06:40:37 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152F713E7CC
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:40:36 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z191so562300iof.10
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=2R9rezOeSZv7hb9r01mgXFWZD64uGjqRDhGdXAtulVg=;
        b=UplmZPBdQih2hIWus+FRTYFwzaN5Uun7IYAhZgFPFvgRLfVxNPQ6ZnhpWMGaqA295P
         6lqrYosXzrV008TU928wfdXdclEzTuMpcTLqEDRHAuMDIBDKQn5e54i7keOCo2DMIdn4
         OJlUVaPhRCHZphV9kQLrB4H0NaBoKau7hnrQ8ePLrZ0s+/uH55ODHd8N28FsSmLjoTQj
         oYsPl+VY7kxosj6gqF4BEyYEs0Lkatwa7a5Yu9NMLLh+TKW5gPZPTwN85+aM41YjX4kM
         QA5czTAEI4UNF+Sw4fChPJgAHauQQNXw4Goy6bb888f6WLLbYzaTonQl2M8lup/Ta7LO
         +Odw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=2R9rezOeSZv7hb9r01mgXFWZD64uGjqRDhGdXAtulVg=;
        b=TP/oVuVCQuyt+IQcQCUhCleXyiETbtI1y2RxJTXreJMxErbyNtxcWJz3SEJhRdCw6r
         9rM4Jgjs32fMOl1IGKmnWdw/9zbvH2FLM9iiuzOKDycDf6ToYGQcD0+ThhpsKCWSwVN5
         f0MDad8vBNR8ZwuW/nK6T1ev6vK1maaGnvNzCucn7r6yKL/vqNv41OlQUtp4w//Tmyws
         umbfSCjCtTAITOTwKSZzebm4hTf5FfSBFozmKGB92pxpVRaoTchMkzqKKmuff39voruD
         KsbSjVCbeRi4KLBxG+BJdwKx+tacYmF/NnR6e075mdwAyXuHXSWpqQuJ46TwrNjpKwXG
         1/nw==
X-Gm-Message-State: ACrzQf0nVkTp0OW4OxuMSvX1THVlkYXOKU9bFjEg9ERdqbWeaNlrQOWq
        2flv72baQJxd1DFmZdMWMfA8Wt713IeEkjJItAw=
X-Google-Smtp-Source: AMsMyM6pjWlsy8L2LDdBTWIXBNq1V046dwOs/m2nahpcOgD8rfaVtCQjLLzSn5VuEcHePtov5WnKHmR/6SFGK9p952c=
X-Received: by 2002:a05:6638:2185:b0:35a:80c:c648 with SMTP id
 s5-20020a056638218500b0035a080cc648mr1475889jaj.209.1664448035492; Thu, 29
 Sep 2022 03:40:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6e02:1be5:0:0:0:0 with HTTP; Thu, 29 Sep 2022 03:40:35
 -0700 (PDT)
From:   ulrica mica <ulricamica92@gmail.com>
Date:   Thu, 29 Sep 2022 03:40:35 -0700
Message-ID: <CAHqv3JU-TOjriA4a5VYnS4ukryqO5mRYtFWGFozn-0KbbpqZzQ@mail.gmail.com>
Subject: good morning
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello dear
Can i talk to you please?
Ulrica.
