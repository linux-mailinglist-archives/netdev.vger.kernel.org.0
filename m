Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA2D60C61D
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 10:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiJYIKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 04:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbiJYIKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 04:10:51 -0400
Received: from mail-yw1-x1141.google.com (mail-yw1-x1141.google.com [IPv6:2607:f8b0:4864:20::1141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364E8733E0
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 01:10:51 -0700 (PDT)
Received: by mail-yw1-x1141.google.com with SMTP id 00721157ae682-35befab86a4so106465767b3.8
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 01:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mHb/+nCRho7yfF3FQtZGTnvq9So8HZiGXQwzzWJi4VA=;
        b=bz81e/0usXZm5n7gZl8bpvJOF4u2aMM8OpFJh1NiIO4qYGD6X/4a6iYGfF6M1tjVot
         KZmUv0nbueRK7vMKe+cIQKNcT6+1LI1O5/phbrL6/4ZGM0Duu/sqDQASENmWNYN1ZIWA
         /fraREe/RC1IcG6UN7DykafZPqTt7Se7bc8ZnBQ/pgYmnJ2XgmwaaM7ug+W9GoYddNkP
         HsqLJfsH6oXlTmfpEvDtjMRJe7nc2utx637Fn8j9BKWhw5tl+1sVhszi8Bo7+lVP2vao
         v++W5rhLr35I60+VjC2BbTuV6B4J7hXdSfozQ8dvh8r6R7fxgHETvNI8kilIiWWwLQqF
         hdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mHb/+nCRho7yfF3FQtZGTnvq9So8HZiGXQwzzWJi4VA=;
        b=iePZDswTyoXuSJwFrDMAkajEfCJW810tMiIKDpIbF3h1DyLgiBs+wSVEvOTC1Wk/24
         d+nIJO0vGiM9ep/L5DPbgb5icz0N8GuLvQoMrBCcfVk11Vfd3DFsGclFzDP7mbD3LcNL
         WYchx3/IYN+heeVrhZSFdAS0vzlUEi1qkGjTM1eAU8TsTnP6EOeBABjYYRGdzMN3FgRN
         i5EaIqaweqWXEHP5jSHlMl0HpvyfSbfuuzBpWsd85eetf7jhCVt0rMgrIi5SBvp0OD7Y
         n/sm0nPaxLztUicAJPp7gHhUw5/fPrcIhGKY7YkDxfSwP1K52F9RAW8Kpt74TiPPscTA
         1Yvw==
X-Gm-Message-State: ACrzQf2X3twVcuynCmbpKrHy/LU+PLE8f3FTySQY44+WNIYD3Y1AcSyU
        srMRTSzkuHDqvFKoN9KXaf2VHld3kK+bl/lQmz4=
X-Google-Smtp-Source: AMsMyM77sk3puBFoiywJau8qK+ObDi4BY61OHgAN8ikzRcr3stpOJs+/PT6b5x+aS+9cl3iMRxjaOvYinl3qB8XCIog=
X-Received: by 2002:a81:9a4f:0:b0:367:fbf9:b9f1 with SMTP id
 r76-20020a819a4f000000b00367fbf9b9f1mr26334996ywg.55.1666685449460; Tue, 25
 Oct 2022 01:10:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:961e:b0:30b:a006:c020 with HTTP; Tue, 25 Oct 2022
 01:10:48 -0700 (PDT)
Reply-To: mr.edwinclark1@gmail.com
From:   Edwin Clark <edclark0110@gmail.com>
Date:   Tue, 25 Oct 2022 08:10:48 +0000
Message-ID: <CAKQTSVpj--B_U9aYNXKSL89_DTt4bLu0ysVic0xCaBidJhbc6g@mail.gmail.com>
Subject: Hello, Did you receive my two previous messages?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1141 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [edclark0110[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mr.edwinclark1[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [edclark0110[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Did you receive my two previous messages?
