Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6ADD4253CF
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbhJGNOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241308AbhJGNOq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 09:14:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B781961074;
        Thu,  7 Oct 2021 13:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633612373;
        bh=AUZjAlpusJmEfDJXie5k0/rzPCK7B1jPGLvEBXKC9EA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WVX3HDDk48j2ePMDRhf8eXaIRWowqKorHDXrJs1/YHS5Hbf++IMbl8tPVwa/4eKtV
         Qog60Kg2uItiCbObDzTkwn+kGuD7xrIk2T8FYE2Is8vfhn+L0Pp2/YnyVfQegp9U8S
         epZ1YuhSnhGlA1KE/jpdSTMlGn0h7hYOipHEerPKi4AraXTWd9saE6EdRyKoSFbaK+
         3F1NAQRSFAv635QlKeDGThowI2a99ZGX9WzFCKlNtKCQuIiWfiO3hPX2HKpDs0hiAJ
         Id8PdJ+LK1lvQXAGswrxD9x5vo/NP4E//1bFAohoKO+3fbKt8g6Fs80eIl0l/e4HiF
         HozfHdrHBZcMg==
Date:   Thu, 7 Oct 2021 06:12:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 12/15] nfc: trf7970a: drop unneeded debug prints
Message-ID: <20211007061251.7642ad58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <47eae95d-d34c-1fa7-fea9-6e77a130aa97@canonical.com>
References: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
        <20210913132035.242870-13-krzysztof.kozlowski@canonical.com>
        <20210913165757.GA1309751@animalcreek.com>
        <47eae95d-d34c-1fa7-fea9-6e77a130aa97@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Oct 2021 15:01:25 +0200 Krzysztof Kozlowski wrote:
> I think something got lost. Could you apply missing ones or maybe I
> should rebase and resend?

Sorry about that, rebase & resend would you perfect.
