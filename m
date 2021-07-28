Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C9F3D8FEF
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 15:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhG1N46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 09:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbhG1N45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 09:56:57 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E24C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 06:56:56 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id y7so1118885eda.5
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 06:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hsteoUNRYcboofRf/Ol7aGcX+KqqCaSHRyisxQe7ems=;
        b=NS1iferfWjeUy4XowZod1JvA2LIHWhM/Mf90x1f1yeOwdoBZ8/vvl4byr/5+IpiYF3
         DcR9NrSdPOOzZUuoOYZBl89QSggat15vSeyCSBVxjD2J9ys3jdBwTlm+TZFe6yZ0Nm1I
         wRYOskUVzjf3bAI6ppttgLw/ptLAgjtiUdx/w99zH8esCE0KcXD/jeLxTBVhWJBwMGUI
         MiifhzQTH0yIav25Ka5uA26iKvbGo6IWhbhPsNH+tbkR8t7PekRrQmRbH/6FsBlCODoi
         Q4rekoiKQtrfJ/v0GLntf+O7Sd8LTwsxPbsF8aql43HFGgvfgSuQ20AxDjWL9Gb4FrBt
         e4Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hsteoUNRYcboofRf/Ol7aGcX+KqqCaSHRyisxQe7ems=;
        b=RfPMmbc+kRiKfplcCreM4aa1bbTmfAB39e7Hj5MZnKAguJ8Tq1cWRq4BOs4ly69PGT
         9j91yDgJM2EkHP2ih+oabGdSrwzzegC5x3ZM/eJ04jZesAzHTKa8vVitPuY+VcOlLClz
         iiTzdFaNbiJQBz8l1h7BFBMsQtryPAiYoiLM60Hn+uS3hU5cNiuCnctepn8MN6EUlh4f
         xvn9qQQIPrT09xTMo/3+2XT39e7odBwNhX8UbCcWllyWQlYssIC3dkOFGU0wGOdGy+yT
         Bq/oMTQXz21ELvxmIQoAsR8denNqePFAluP5Qlvva05bBDHJacLTJB9duQT1JFLyfP8z
         /sqQ==
X-Gm-Message-State: AOAM5307l64wSNlaXvvabXCKzVD/4hVwWwzcl6RCuI9zBM+iKCNg+pYO
        ePbqqzNewm5lTpIRMWj12QmUhVKFdrhdPnLJ0GY=
X-Google-Smtp-Source: ABdhPJzjLZ9/gT9D69IjCiviJEEQLA59bBcrdgz61R82Tth2nk6p8jkK+v+BrjSO//sxgbcZQ2aesw==
X-Received: by 2002:aa7:cdcf:: with SMTP id h15mr3607327edw.45.1627480614811;
        Wed, 28 Jul 2021 06:56:54 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id g10sm791713ejj.44.2021.07.28.06.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:56:54 -0700 (PDT)
Date:   Wed, 28 Jul 2021 15:56:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] bonding: add new option lacp_active
Message-ID: <YQFiJQx7gkqNYkga@nanopsycho>
References: <20210728095229.591321-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728095229.591321-1-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 28, 2021 at 11:52:29AM CEST, liuhangbin@gmail.com wrote:

[...]

>+module_param(lacp_active, int, 0);
>+MODULE_PARM_DESC(lacp_active, "Send LACPDU frames as the configured lacp_rate or acts as speak when spoken to; "
>+			      "0 for off, 1 for on (default)");

Afaik adding module parameters is not allowed.

[...]

