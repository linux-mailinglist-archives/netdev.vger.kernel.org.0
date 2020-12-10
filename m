Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB4A2D59DD
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgLJL60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbgLJL60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 06:58:26 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5CAC0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 03:57:46 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id q16so5165948edv.10
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 03:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6NbnSuOLUoxdpTktL/1IwfktGPGoYvrME7jpvlwWEEk=;
        b=HVd6+pbrxhjU5GtXpnZGfRok7L42PXotdLL9G7cINUakaGtCayY7olVa8X292GcYac
         dU1kPzNR/Ftdl4fvoDIup4QdKWuMsLJMtYqZ5zmMoBoykdbsisAsCp72ms41FAhB0m9T
         OZsJeqvkfnlSvw1AeaesrEo0gaWH0z20pJWRu0sPTZrmtKqzvLq9eLcOC+lzlN7Sp9zO
         +KIBfVNLj/IA/G2mdnSVD+J5+8EOUQrG5kfPhk80L5rElN2d7BZ3gS0uUMiFCEsxzmNc
         HGA8sxGu7Xd1GS9gBEIXQ9VHiaqDmXMXuVLunuLQdmhvdfMk98YFYPHLAvx1pO3Y0Uen
         iHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6NbnSuOLUoxdpTktL/1IwfktGPGoYvrME7jpvlwWEEk=;
        b=OCr0uP0m2tlEVoRSNDRIq6/eYNUih27DGHSHqoVy2DDAneTuWuxef8sYjDtMwbYKA8
         k+nEGhqXtCIWqbr4h3qLm57Z1zauY1sftYSNRj1y+WgruGh6Z+83h0avywIi6Adww0w0
         PZ824bSBE/uoqBF46aUFG+fMn+Z7ZC3iAGHTcJhQw3A9Qipe4V9FEZAqW1SjCySeXiqI
         S0zqOIYqNnff2Ve2k4WKRvC61nyDsN10koyE2jaS5QuyDWA/uQAwcsBCgGjjumf7qNia
         4xyJJMeSzhQ0zXaHjtcAraNFcesNlNcy/v3k1YHRMXNhiwg4cOrBjwxhGl7qS4kGgi8O
         vWjA==
X-Gm-Message-State: AOAM5320lfe7/PbDzmj6iOaj/nrex5WgCRAvZQ6ktpAY8Ab5kGgGc5T+
        Uc9KnZUNoE7ZfwGxXAlIHURyyiLSXN6V6oJVechUqF0kAAIr+g==
X-Google-Smtp-Source: ABdhPJwYXTam41JcVgJQx6EXb65+tX0SJZwixmW4YOfp8VAKOvSae9syMO8ww1utQA27tfrHNYamsOuL/rt1FomQLso=
X-Received: by 2002:aa7:c3d3:: with SMTP id l19mr6541669edr.366.1607601464866;
 Thu, 10 Dec 2020 03:57:44 -0800 (PST)
MIME-Version: 1.0
References: <1607579506-3153-1-git-send-email-subashab@codeaurora.org>
In-Reply-To: <1607579506-3153-1-git-send-email-subashab@codeaurora.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 10 Dec 2020 13:04:12 +0100
Message-ID: <CAMZdPi882hVdO-N5GKiCXy07kPOBXFzi0JZ9auKb9oKu_amW=g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: qualcomm: rmnet: Update rmnet device MTU
 based on real device
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Sean Tranchetti <stranche@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 at 06:52, Subash Abhinov Kasiviswanathan
<subashab@codeaurora.org> wrote:
>
> Packets sent by rmnet to the real device have variable MAP header
> lengths based on the data format configured. This patch adds checks
> to ensure that the real device MTU is sufficient to transmit the MAP
> packet comprising of the MAP header and the IP packet. This check
> is enforced when rmnet devices are created and updated and during
> MTU updates of both the rmnet and real device.
>
> Additionally, rmnet devices now have a default MTU configured which
> accounts for the real device MTU and the headroom based on the data
> format.
>
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

Tested-by: Loic Poulain <loic.poulain@linaro.org>
