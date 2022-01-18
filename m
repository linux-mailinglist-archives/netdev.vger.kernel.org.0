Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5012C4929F3
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 16:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242968AbiARP5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 10:57:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33344 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiARP5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 10:57:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DBBF612B8
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 15:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4945EC00446;
        Tue, 18 Jan 2022 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642521472;
        bh=olVrwsmqiMbILR5CwZtAifQfaDXGIDyPGLBiS49allU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gKPssu939ypulSkvogq1GcrUAfsWZG1yHvhKz9NTN3t7fWQLpYRrH24l5PBj1FFB3
         q0s33RtXpTOWCkudbDOdT2KqMlvnbg1MFdPdf5tlO2sUAn9ty1zsWohGujrfaInM+w
         A6Wc7d05za5Iv4nRrg/7geEkBvMEjqeCqhRMK/JqEQsV5KWbeGd7UETMtP1SFqnhjr
         ZA3cfSSl19nBfhFeYBxEbCdzM2KnY5sQ0U7/D6MTA+5jq35Ifu6fx4AUHRa8pRl6Xx
         P5G6da3WsIy1Z7j2KQ+sDDfifbP48r5bVrfEkH07YbLe7k8MsTSGv1t0kbebfxlPbO
         3cKpQ6hJ1BMjA==
Date:   Tue, 18 Jan 2022 07:57:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     Martin KaFai Lau <kafai@fb.com>, Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>, zeil@yandex-team.ru,
        davem@davemloft.net
Subject: Re: [PATCH v3] tcp: Use BPF timeout setting for SYN ACK RTO
Message-ID: <20220118075750.21b3e1f0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <7A1A33E9-663E-42B2-87B5-B09B14D15ED2@yandex-team.ru>
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
        <20211103204607.21491-1-hmukos@yandex-team.ru>
        <20211104010648.h3bhz6cugnhcyfg6@kafai-mbp>
        <7A1A33E9-663E-42B2-87B5-B09B14D15ED2@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jan 2022 18:26:45 +0300 Akhmat Karakotov wrote:
> We got the patch acked couple of weeks ago, please let us know what
> further steps are required before merge.

Did you post a v4 addressing Yuchung's request?
