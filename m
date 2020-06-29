Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CAE20E5E0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgF2Vma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbgF2Sh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:37:56 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702A4C02A57E
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 06:51:38 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 17so16188910wmo.1
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 06:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZN7s0rpUvm7Thu+X4HuvhxL1IG2024/Ziv+xnuMnyFI=;
        b=0tAdGslaZFcM41AFGeXe/Vloz68UyMcJmY982lv+aoUTrVKpn13RAKDUyMID8YmCAi
         W/6wuChnH5/0vNKTdcACo74o811HExiZBrN034X5BRKQpFIA5c2OBalAsWgqYLZ1fDgX
         hLebD+eZ+zbBFogyVNM2MuR7vaVeZChhABbfGhNkMUZmcAYiugExD2zqR2spUPKywtrG
         U36e5CqCoP698VLNRuQl5nf9NQqCepOkhP/OKNp6zqBr8H8T66pDA/j/9KlmHTCp9Pno
         adgfnJaEuEKyqdjH9XQ25cNGOQ3q6fTO3efAjXmUOqarEJrIwv21cnUXJbFEaMX9T8Eo
         7f0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZN7s0rpUvm7Thu+X4HuvhxL1IG2024/Ziv+xnuMnyFI=;
        b=Gm1eG7OY/Q7282Gbj908dsjEUyCidUtMlr1aZDBVNzb3oJqW2+qzq73LB8/tpXntPw
         yCwZs6OOX6r5BQ0K3X72YYwrjezsiXCqQ+KecXUGkrubh5xkqt6xYCiYGJN7nqNKpp2R
         TbitBxR9NhcZFVS1I67GihJl11tiXd2vdUJJ5xLAdP/bC5VU85uptInFFgzQpwUtpvpO
         RFaAYdApF3UEO3evTjJs5aFi8r5Imd+468Vhij4a7KCZcJhh+Kc47bEU5Sb1cbBlX+z0
         QD7ioNHqddkey18PPbP55lFKLWMaEUrDQm2vjSJy/b2ZJ8XZVgBlW+pIGIL4POsV5vxW
         teYw==
X-Gm-Message-State: AOAM530TbgYT1zrsCmf+rEPmFNiadALRWYkgzLAYLUgBQPzI7zjrdDrg
        1Pr7Xp0TTCqa/fBI6OVbpUEDTQ==
X-Google-Smtp-Source: ABdhPJwh4VzxBzKQoxs2AH7nIvWsBjTb7JcGXaRKj888y6iE2vidGGjNPDEJQlcfCUhTfGElhkVl1g==
X-Received: by 2002:a1c:bdc3:: with SMTP id n186mr1650242wmf.84.1593438697070;
        Mon, 29 Jun 2020 06:51:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p8sm12593183wrq.29.2020.06.29.06.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 06:51:36 -0700 (PDT)
Date:   Mon, 29 Jun 2020 15:51:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, kuba@kernel.org, jiri@mellanox.com,
        moshe@mellanox.com, ayal@mellanox.com, parav@mellanox.com
Subject: Re: [RFC net-next] devlink: Add reset subcommand.
Message-ID: <20200629135134.GA2227@nanopsycho.orion>
References: <1592911969-10611-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592911969-10611-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jun 23, 2020 at 01:32:49PM CEST, vasundhara-v.volam@broadcom.com wrote:
>Advanced NICs support live reset of some of the hardware
>components, that resets the device immediately with all the
>host drivers loaded.
>
>Add devlink reset subcommand to support live and deferred modes
>of reset. It allows to reset the hardware components of the
>entire device and supports the following fields:
>
>component:
>----------
>1. MGMT : Management processor.
>2. IRA : Interrupt requester.
>3. DMA : DMA engine.
>4. FILTER : Filtering/flow direction.
>5. OFFLOAD : Protocol offload.
>6. MAC : Media access controller.
>7. PHY : Transceiver/PHY.

Hmm. I think that you are mixing things which are per-ASIC and per-port.
It is confusing.

Why do you need this kind of reset granularity? I mean, if something
goes wrong in fw/hw, the health reporter should report it and recover
it. This looks like you try to add another interface for the same set of
problem...


>8. RAM : RAM shared between multiple components.
>9. ROCE : RoCE management processor.
>10. AP : Application processor.
>11. All : All possible components.
>
>Drivers are allowed to reset only a subset of requested components.
>
>width:
>------
>1. single - Single function.
>2. multi  - Multiple functions.
>
>mode:
>-----
>1. deferred - Reset will happen after unloading all the host drivers
>              on the device. This is be default reset type, if user
>              does not specify the type.
>2. live - Reset will happen immediately with all host drivers loaded
>          in real time. If the live reset is not supported, driver
>          will return the error.
>
>This patch is a proposal in continuation to discussion to the
>following thread:
>
>"[PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and 'allow_live_dev_reset' generic devlink params."
>
>and here is the URL to the patch series:
>
>https://patchwork.ozlabs.org/project/netdev/list/?series=180426&state=*
>
>If the proposal looks good, I will re-send the whole patchset
>including devlink changes and driver usage.
>

[...]
