Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38BB65D3BC
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjADNGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239369AbjADNF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:05:57 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB7F165BA
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 05:05:51 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id pa22so16220479qkn.9
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 05:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g2m/uNsCm/OsAUZxAnJOSdXXDa9Gh4wg88n4VPL2lMU=;
        b=CvL+ep+/rtWoqemfxI7wMRAa6l5m75uCs0NkeX9c/LvgwQeBe2yteZ282qet7LqK3e
         HxG/Im0ZM/D1WODWOklWQLf7OSL2rnEYePbCC3kd5S7iXTIHk2TS9m4HXqg7X35SFalO
         la5iGs7bIa3/kTqN6sAmkNh0hoDLXQ/We3MdB2P1weN7ux+DF08kDg/6A/Y6YfgRBxcY
         KtDFS1uPETmKgl0qf8DjC302y7mP/AVrTIbIo86apj+J47m+1pZNy3GOJxen9dicVXiY
         BsuY33L2i2P2qgBdsZW4+/Yf2ArRdKBESHT+mFor1aYszrVEnphp0wzk59LkTEnCXMpY
         DxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g2m/uNsCm/OsAUZxAnJOSdXXDa9Gh4wg88n4VPL2lMU=;
        b=fTKRhbFIgMP12todyjx9+vUzV9ptk9lkG8rs7oJ1OVT9Hf8zroc5MMB/oggSoMfSFt
         flM+RtfljlVGfE5fkWA7S5oEjRs+PCX35s/iIRI5vVeJ8uouFu3cBkJBkPTVBPNk8Voh
         BB3QBhJYIazFNRqbPtWgOeLVSo/4bGhnbzFZKuS8PpCRaHlbJGEbV2nt5ngOFcFy7hnf
         n9UwsaYCO96RhjffR2zQtCaUzlyCE7xhK79I9/zbwn8w5RChWhAGtlAx12191TH8sckX
         +DxSSTEnO56Wq1phMPOi2OtT5phvr55mTT5qwgwck0deDMU4JXB/5c2AsPLykXuF2H0E
         MPjg==
X-Gm-Message-State: AFqh2koEeZBq7TpqDL0C3nrpqsiF7u5ycEqpeB8qMTkdj6jg+4BPWlPa
        U92Ah39nC8iqPg2IFQtJUo0bDtZW4Tp6w2bSH0k=
X-Google-Smtp-Source: AMrXdXu2OgEBObdRdbMNu97JgXKPUIU/iPSgjknWbpkI9oHVVplu/0eITEKHSfy21FjM4TZO7YYYJ2NT+qIkDRPzmNA=
X-Received: by 2002:a05:620a:1327:b0:6ff:df2:2936 with SMTP id
 p7-20020a05620a132700b006ff0df22936mr1594016qkj.138.1672837550090; Wed, 04
 Jan 2023 05:05:50 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ad4:574b:0:b0:531:bf92:424d with HTTP; Wed, 4 Jan 2023
 05:05:49 -0800 (PST)
Reply-To: Gregdenzell9@gmail.com
From:   Greg Denzell <ketiaxbusux@gmail.com>
Date:   Wed, 4 Jan 2023 13:05:49 +0000
Message-ID: <CAMG0K-Sr6UEGeS3F8yMsn1s0JW0MpyFf3Mbwf-181tMy0XDkMg@mail.gmail.com>
Subject: Seasons Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seasons Greetings!

This will remind you again that I have not yet received your reply to
my last message to you.
