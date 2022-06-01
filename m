Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA69B53A916
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 16:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355459AbiFAOXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 10:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355611AbiFAOXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 10:23:31 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E59F7493
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 07:13:05 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id y32so2973615lfa.6
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 07:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/ccjjvWMS5/DGlPpKxbVBAIw+k9p5V8WE8raejRbJ+4=;
        b=iLkqN3o2nnEX8q6zscabsxi7aWAY0KrgnJ9DcA1koKDuy8Z7KmsSAsR/M+N6TmeqYt
         Xm0UbZZ/T+L8+roLrTiAN/XQ2rB4h3dreo8s/zUV2e1fwSsGuIvwghJLLuK3QV8LEEzs
         5YPHIwk4W+JdWFA4pShdMQhRpfbNXAFSOJ+C9JhqqvHQznbmIHcMkCGN0nROtjCrgPxr
         pUBQ+UOtZaAiebg+E+Sl+skHI06/5AZyRwLlQaKBPs3fUzJSPIUCbOwmMnn4t64vwr3u
         krVMgpMMQtd2ZL/oYQCrOQ0bQm+7TKfBm3QWo0Sg5xtObTEI1IBtFcbxmZnlLHemacp8
         KdpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/ccjjvWMS5/DGlPpKxbVBAIw+k9p5V8WE8raejRbJ+4=;
        b=8JhP/ZPfy914Vz6LQvyR05t8jmK3sxcXatpz2YDG2GTh1jmkFlV6eEIJ8mn2GJFrg5
         l7dIp6PppD0fjBeOcVRJrIoKULVXeAf/+/pBJwB6/igEi9Hk38nYFuwWxDWNckqntVhX
         41oXSW+/aqqMaOvTwOQvYn38rRUm7KCSB/6Rau5D7PNk5p4NdWVlAWTV4zlYTuLFigcw
         2i4OLjdd3OOMXBWmQOaZ+z2J/HEtPl1O/3X6OF65LplZ5FEouuerL7aN9x+aCFp90yza
         W5/kyVQ3oZ/fzA9LSMZL5iVdVsGBcRucWsR5wUy4F7mjv56LHw+SqVn/RfnP50Ud6Irt
         bIiw==
X-Gm-Message-State: AOAM530DX4wsgz5d/FpN1j2RohJMAgclP6mFDXnM4taJ+5DJ3/fOJ/+u
        HOuqv4bn2stgpszpBCxU0KoCoT/16ad8PTX1FkQ=
X-Google-Smtp-Source: ABdhPJyWwh7cAe/dWFyAnIFyuBD7XiLD55QlssgbRzhwH0CmXGasmhGqhrt/b+6ONrgfBvT1cb76l3um9r8QD9RPPzI=
X-Received: by 2002:a05:6512:398e:b0:477:bcc6:f45d with SMTP id
 j14-20020a056512398e00b00477bcc6f45dmr34945405lfu.216.1654092783404; Wed, 01
 Jun 2022 07:13:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6512:6c8:0:0:0:0 with HTTP; Wed, 1 Jun 2022 07:13:02
 -0700 (PDT)
Reply-To: williamsilvana3@gmail.com
From:   Madam Silvana William <www.mariawilliam2013@gmail.com>
Date:   Wed, 1 Jun 2022 14:13:02 +0000
Message-ID: <CA+XNVK_y=mjvDJ8AqsXZTYV7yQTZw355mY9e6E8C=LSjr-TPhA@mail.gmail.com>
Subject: Hi,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Did you received my previous message?
