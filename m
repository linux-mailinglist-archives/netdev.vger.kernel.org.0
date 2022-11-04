Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8219619CBF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiKDQNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiKDQNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:13:50 -0400
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F310C1AD85;
        Fri,  4 Nov 2022 09:13:40 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id l8so7018588ljh.13;
        Fri, 04 Nov 2022 09:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T0MZx5H+KKojBozLD9F/surnKXHJHR40WHSVlsC6T2M=;
        b=JqOPAo4re13aY8QT4ZKKtC+pBI2aSdvzeZDZ0NSLgHTlg4IX2r0eU2lOBl6Sxy6rp8
         ffyfy8FSt+RTCztcQ9gZayYL/ZiDB8hBtTHcUtKycZXgZm+cpmfm/NDy9KuRRKIdbEXR
         nMRMf14/kYPFZRBBUTrG4hw1QOSKsLGh5m7zWNigGyJTCg2Yv+k0XaZX9qZT3FSgzFiS
         97iXfQmNFaVP/U5lj2EWXr9pDrPmoT/8+BoDkTqQZxR37vWoWdY8aH2+des/FKJzH0S4
         2oNCz4hF7dmZYEglUluEkh98pCtiSlLjSMvBIMl5ELxZa9RRiAQQ47XDXk4+1pnnOwD9
         RkjQ==
X-Gm-Message-State: ACrzQf0tpLjDibq740aiq6Xx9UCUnFuj2c5+LcjMS69WF+trS4UHGt6L
        JzEjbMa/S+NeYVsimNfmbkdidOU/hItg8zTl
X-Google-Smtp-Source: AMsMyM5bY9p8r2pmpmvpD/ree8hLmcCQMd9H+lHQZKA4DgRyG3EY2fsn25pXTt6wLhM47xSch6X4pQ==
X-Received: by 2002:a2e:999a:0:b0:277:56a9:4a39 with SMTP id w26-20020a2e999a000000b0027756a94a39mr9954959lji.333.1667578419137;
        Fri, 04 Nov 2022 09:13:39 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id q21-20020ac246f5000000b004ac393ecc32sm495567lfo.304.2022.11.04.09.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 09:13:38 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id x21so7026817ljg.10;
        Fri, 04 Nov 2022 09:13:38 -0700 (PDT)
X-Received: by 2002:a2e:8743:0:b0:277:10a8:3e8f with SMTP id
 q3-20020a2e8743000000b0027710a83e8fmr12867538ljj.423.1667578418373; Fri, 04
 Nov 2022 09:13:38 -0700 (PDT)
MIME-Version: 1.0
From:   Sungwoo Kim <iam@sung-woo.kim>
Date:   Fri, 4 Nov 2022 12:11:08 -0400
X-Gmail-Original-Message-ID: <CAJNyHpJ7hbmDK-Tq==L1D3gWB2ac4MTVYynf57JM0GmEN9-i7Q@mail.gmail.com>
Message-ID: <CAJNyHpJ7hbmDK-Tq==L1D3gWB2ac4MTVYynf57JM0GmEN9-i7Q@mail.gmail.com>
Subject: L2CAP: Spec violation
To:     marcel@holtmann.org
Cc:     johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Our fuzzer found a BT spec violation, illegal state transition on L2cap.
Specifically, l2cap_chan::state is transitioned from BT_CONFIG to
BT_DISCONN by CONFIG_RSP by following trace:

l2cap_config_rsp l2cap_core.c:4498
l2cap_send_disconn_req l2cap_core.c:4585
l2cap_state_change l2cap_core.c:1618

According to the spec 5.3 vol.3 part A 6.1.4, CONFIG_RSP cannot cause
that transition, i.e., CONFIG -> DISCONN by CONFIG_RSP is illegal.
It'd be great if we could discuss.

Thanks,
Sungwoo.
