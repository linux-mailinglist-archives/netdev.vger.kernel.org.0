Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A67E1CBD95
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgEIEuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgEIEuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:50:13 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73271C05BD0A
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 21:50:13 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s9so3210024qkm.6
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 21:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o1JFY8qJmZXd/aUl9gDLLurD+wehBfsqo8Bz40G/nWw=;
        b=J16hc94Nk376MVeMGTdJs5OJAz/Ehej4THCEf4foNANL5Yu/B80oKDrU/aEmsxYPfE
         R6PyDEMbV0fqJYLmIXzRt4HBWSDOIp6+311zEYOxL2u8OEC7+60bkC3pBAib3EXph7Db
         TEgkBKRmiOWR8nxpGR7MNewvquOMd6dRRkxm8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o1JFY8qJmZXd/aUl9gDLLurD+wehBfsqo8Bz40G/nWw=;
        b=BrSkSqcrxBKlTiNCftFtC8nnbT2q5BAopANxxttOgNLJho0efkSC0dryS/H2uBexnH
         m9OehJCNhSW1YXKwEmM08jS/hW/6Si1RmtFYj430a0QDVL6ayugF5O2Y8nw3h/ticBMm
         LeYC5DRPBvKXNjYxnjn7p94ccDGCRHZT6wssdv5kxjP/oarhKN8dOcEAhzI2iLBdghF7
         lSDPKKkqSbrIW20k6W+3rBm+9Zb5VYuQSJ1DwKMEcoyLZLO7pfgS0Qpot5kTReyOFZOi
         UO/dS8kxd+Lb8McUiM9Sit861tzNQO5oN/EkuwXQcDCIAMZBSnu3DfTr7diGaWetXv0k
         WC2w==
X-Gm-Message-State: AGi0PuajsKFf61JYKUS3Y/4hTVeUUXTEAx6wf+nncUg51xt4sJ44SqT3
        H9OueTJeMtf9DpHVC5qMqaNWlVc19z/M7s6Kr8QixW54
X-Google-Smtp-Source: APiQypJBp2r6Es5PVpPUyc2m1NAUrTMh1P00GZIlWuu0gAXEIz+sgXN+lihgtlNrzkjKnptXRPhsXJbgN7ojbaB5dNU=
X-Received: by 2002:a37:7443:: with SMTP id p64mr6032310qkc.269.1588999812631;
 Fri, 08 May 2020 21:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200508224026.483746-1-colin.king@canonical.com>
In-Reply-To: <20200508224026.483746-1-colin.king@canonical.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 8 May 2020 21:50:01 -0700
Message-ID: <CACKFLinBL4QCT6YcTn=exkHAitXHd_D_XR0zHwT1zuMfKTyWug@mail.gmail.com>
Subject: Re: [PATCH] cnic: remove redundant assignment to variable ret
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 3:40 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The variable ret is being assigned with a value that is never read,
> the assignment is redundant and can be removed.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>
