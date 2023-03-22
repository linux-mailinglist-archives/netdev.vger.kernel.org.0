Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF4D6C4B01
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCVMrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjCVMrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:47:32 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214395B408
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:47:25 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k15so9707478pgt.10
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679489244;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=Y4JScDlUX2PtI0qleZc+T1hFGcNU6XQ24Rf20VvGtw340O2HmrsnlwonKUXx6CkGml
         wTsGIvyx0L+K6GgscBC7a+66Z+RTLIuAM0G1ral6oSwQLBsg/k3/n13Cr05efkedlkof
         yeEZPPWXurswyUrkClalPWA9S1pkJiQ8DcNYjDUqXsb/z5bUhLVV7vZ25vnCBjkcm5jl
         hpSC0JtRVBv4Zt9CIHPUPOQ/HhBAQ6a8mzDN3dowvlX+DFD3LtKsvHXqZrMIEu2dLgZF
         e+dkNuvuvuZTR3gca6xHmufSDrOu+6Vnc5r3UdPq0G6R1wlKMthnB8gv1Y6c6Ft9ctfB
         9joA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679489244;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=vn7glZS/p9beoGlVLd9fo8egPk7+MZWOLkH1ThIOrNo4tf6+4qMft59zdff9ruMQwv
         fIPUC1/l8tbcxcOR6iIevostEEBhnqvFQAuvqaFMmcfD0YpcV5fcCMdldNjq5eouHft1
         z8ayzyLKd1F7Weo4u7TAzxdwxOueB1xtkh1mmKbRv7mp7NzKJBScCtF37xkCHAj7WRIW
         3ou4hKURElekBrYTGgn4TRhsQRDcgP3EZNqYbMoR367Yr2pCWBmOdg2QsgHFDCZEsEsz
         3IRVUFZAJej5eCqeyli1tDbKdFF9Ex77nwL4xXfeMsEI2+fHLTzbT1WFGHjItbyLGf5g
         y44Q==
X-Gm-Message-State: AO0yUKWQn/rsLa1ZziKuJbyrXjMNi8WQ0bM9rInOOw47jYwfid/QKPqH
        AwPOS8RDsCHBU2vnPXa9zTMmkOYFUL4dSmFJK2w=
X-Google-Smtp-Source: AK7set+9DbnVs187OLqosDr9IpsDfLXDAd6Vw0ghbIpOeo9ovgNf6RWqnan5YxXTziMtE23I342ZUsYCshnZnTtRT/8=
X-Received: by 2002:a63:9a51:0:b0:50b:18ac:fbea with SMTP id
 e17-20020a639a51000000b0050b18acfbeamr751112pgo.9.1679489244329; Wed, 22 Mar
 2023 05:47:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:522:86c4:b0:4e4:4a0c:2495 with HTTP; Wed, 22 Mar 2023
 05:47:23 -0700 (PDT)
Reply-To: ava014708@gmail.com
From:   Dr Ava Smith <adue84540@gmail.com>
Date:   Wed, 22 Mar 2023 05:47:23 -0700
Message-ID: <CAEW4dsjg_KvFF4LKUpXaf5EdX9-vkciwQiHd7Lwv49shQzwMew@mail.gmail.com>
Subject: HI
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
