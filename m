Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929184F131C
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 12:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357829AbiDDKbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 06:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357888AbiDDKa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 06:30:59 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07129FCB
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 03:29:02 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id bu29so16460140lfb.0
        for <netdev@vger.kernel.org>; Mon, 04 Apr 2022 03:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=UIbSwXETQo8py8NKWWoOzTbdb19k4UaVxjqlebXhaiE=;
        b=pyggJQgcGfVukpdEuL2zKyP35LlFiU/flU/v3N7EoxWB4i0hx2KHhCLjbBPF4/R0SB
         VfePOQOfIgP86H2dJrylxUMMk7Q/EQ6NMPnz1EvSEcWF9ezNnPJpcNcbYZ2HLo0k27Nx
         gmEAq869PNzvU4Nq57vKkq0aKnI5y6Jx6KYzLOxCpfLgqwc8jcGpeO+HfEe2xZJr5SRQ
         kfir40RdKfnWgvUIUHkNqRXbiiA2ydjufknZQJNLh3jfhqD2zbWfkK1oeqR6eoPNc6zi
         FhPJ0qyC7RiLeESONIs3g8nNqtrQHsZsrLOb/WwriexWa11GDZsoxGXutdryaUcDWU8J
         NRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=UIbSwXETQo8py8NKWWoOzTbdb19k4UaVxjqlebXhaiE=;
        b=qXuuAR09OouGdJJ8ZfuuvGOqGJFicsyB6E/FKOfXXobWLkPhd4scdav+IKS6gjTOCz
         u3uDKyBNBsW5Sdby6pLTbfLPv7TcAIC32sYhMQPkfjQPWaSzDzPMqrNt95pLEn1hvz+4
         qu5eKxK5uTxEF/iRXdypfZrD4zOoxGlPk1L36jsmAlu6Y64p8jT8FVakQqOYxGYpSu64
         pGnbb84o7gLsVg130vvR9PpCCa7wLGidsrV7Xi0XfppkbUpOcD4lathL9hlA05brgArF
         A4Bq4ULA3sEWflF66OaSPBx4kkXZuWzaY459fW/+R5p7dNDaFnZJf2QM5ah3jsbTaSfe
         OiDw==
X-Gm-Message-State: AOAM530STL6X+vUOBialnGsFTZ7D+me6sStcJceJzLAltA5Mi3tUqtVk
        CdRK+AccRT4UDEMTXj3btUjHoRJHestAiEgN50U=
X-Google-Smtp-Source: ABdhPJy55/BVB79soN5slhzhUx6J9CorGlW5mN0xysiDIVW++pj5vNCa40VV5hS9vAcIN7I9l7bbOx7fsT2hDoHiiuc=
X-Received: by 2002:a05:6512:15a6:b0:44a:a117:f1d3 with SMTP id
 bp38-20020a05651215a600b0044aa117f1d3mr22067146lfb.216.1649068141254; Mon, 04
 Apr 2022 03:29:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:bc06:0:0:0:0:0 with HTTP; Mon, 4 Apr 2022 03:29:00 -0700 (PDT)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <fionahill578@gmail.com>
Date:   Mon, 4 Apr 2022 03:29:00 -0700
Message-ID: <CAFw126Fh+HJBS8r+WZDJqUndrfxiC3qA_HxmUDByDSEuPsm_-A@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello, did you receive my message i sent to you ?
