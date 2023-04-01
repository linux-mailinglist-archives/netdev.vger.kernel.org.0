Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B426D2C19
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 02:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbjDAA3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 20:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbjDAA3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 20:29:43 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81CE1D2EA
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 17:29:42 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id h11so12373228ild.11
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 17:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680308982;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/mk2nPyPDHF2nSoHYsdcPx4I1t1gE9idID2faOY4LJU=;
        b=RAIRei9HIvjgK9sGlLUdgww3Y9S3/mtRRCTlhFk5f30aXXorcp5lml8eCdDE8ghonH
         WF3F4vsUtrIX8yf8uo5HzhMxHDtgqZuxGPrrV785rmcLibhNozlCdCD2s4o9c+YcAg+7
         34Uo2gnxeIsCcFJ+jglP4PrIf+PON9aEDeySkZJGBk7nR9qYzUgEvqcGicsRcd8t0oOt
         UZv+EuFd1DBDRksdJXmmxr7pXrM+h4LDcseHN+SRtmOSwAEHUJ+6GZJSqpCxHJxg5Sxv
         2ccqUMN6g+bcUte9IlxV6lCgQTwlkct4rc4MMoBiEh19MAflyKX8m5YfCZ+fQ6D5/EY+
         5jRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680308982;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/mk2nPyPDHF2nSoHYsdcPx4I1t1gE9idID2faOY4LJU=;
        b=wbdv0l+QlRyy6I2VHY/i2hH5JR9TxZyF/GkVWAtR/p7pw44Q/ciljpA20oaAbn5YWr
         877zoQKUHsFOmsCJn5EiJiIjrH8cska+aO+EjTXlpEECPrWsF3fHAq7a2yEPYuxru5pc
         hYi0HiWS1Vych8pWkmKqsD5dOTlrSs74QPyY3L3yNv44HTxVuSCPgxQdnRbftQtf3T6y
         gU/2CqErDB9nmFQev1KGXtesmZwBf5CD427gtdj2c7BuELhO8Vh0KHOgyGSHEi7hadki
         ctjtVcMNO6uPVlvk/cxTrneDimYTKxy+i8KjiE+2mtVgGzzfGdvkj/9cys8Hb2VXLhL8
         EbYA==
X-Gm-Message-State: AAQBX9cBDjLEZ8nokQyOCF0Ojt+DdHDmyNc8dXq9oa9svL/Yivk1YOAE
        3xl/2wszeu+PLF8PRj8v+ABERloL/VNcLsRidQw=
X-Google-Smtp-Source: AKy350b4SNkFQbF8f3eF0zlrVgBEZByuQDtGUy2ZI+kCDHuI5C0fwbMOuGozEOZmtcpLRSr1K3CCyZGPoC0Xy+jDCT4=
X-Received: by 2002:a05:6e02:cc1:b0:325:a8e7:126c with SMTP id
 c1-20020a056e020cc100b00325a8e7126cmr13946198ilj.0.1680308982095; Fri, 31 Mar
 2023 17:29:42 -0700 (PDT)
MIME-Version: 1.0
Sender: samanpyabalo@gmail.com
Received: by 2002:a02:cf2d:0:b0:404:a526:7a9a with HTTP; Fri, 31 Mar 2023
 17:29:41 -0700 (PDT)
From:   Miss Katie <Katiehiggins302@gmail.com>
Date:   Sat, 1 Apr 2023 00:29:41 +0000
X-Google-Sender-Auth: 2Lzqv0NWoq2kilHtrSWgyqDxzpM
Message-ID: <CAMbVUx4Tet7W8uACnTTnPs_5gqDk5WYWO8Hy0RLZdE1Zdhpc8A@mail.gmail.com>
Subject: Re: Hello Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hej,

Modtog du min tidligere besked? Jeg kontaktede dig f=C3=B8r, men beskeden
kom ikke tilbage, s=C3=A5 jeg besluttede at skrive igen. Bekr=C3=A6ft venli=
gst,
om du modtager dette, s=C3=A5 jeg kan forts=C3=A6tte,

venter p=C3=A5 dit svar.

Med venlig hilsen
Fr=C3=B8ken Katie
