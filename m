Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED342CFD2
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfE1Tz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:55:26 -0400
Received: from mail-vs1-f46.google.com ([209.85.217.46]:35699 "EHLO
        mail-vs1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfE1Tz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 15:55:26 -0400
Received: by mail-vs1-f46.google.com with SMTP id q13so103479vso.2
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 12:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=x6dFwvFcfN/yzg7b/lIRQdOALjxQn0xMPMueNRFJpik=;
        b=iPZ9wTimgfBr1g9wirumlcNdcExgX/rBxGOORzaEhjV4MqHpyTPI6T3BKH5oQ4j5zo
         AelKs3rBsCU3DJ3CUFNUo9tnu1DIAprGUNrK8x8cZRYJk5XwDT6LoY1g3BJdDVNxEWF9
         EzcFp2Wckd/kTGthoigsxZLPwUhBlZ2o4tMU9NshbmFteXzeIR6R1wiH+BrE5O+i6a40
         AATkBxIqpfEKW6Pi4/WfnDx8LZVLhUeZhBJiyQPGo363E/hiwJAFKeVaehwl0QLy0isX
         Ekar/WYYrQTgt2tbO8QfCsIwa+8Mbztnuz01TF78bkeXpsGkfDIzLX+perqPeyNFT4qc
         lDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=x6dFwvFcfN/yzg7b/lIRQdOALjxQn0xMPMueNRFJpik=;
        b=lF61j55YcEOF0hGiDUKO3nzOlWh3gnyR2dWmC8IBC7iEAHTxdlz1uzenZ1kHrqzYsD
         Kr2qnNKkcOLqdnSVTkODjKa3bZHa8Xp3jlC76iXLQfKms5nS01MHPMXpblMNog6T73/V
         6OIIZBo6k2cjsZgvhC8ctzPdWsmrK9WgJN7zr+4leipAOzWA6mympG/zqM37BKrbYlAI
         zhgR2477p4vLYeWWf58nYxHbuY5yjiGUUNFaH6GKOq+JfXX5ilMeC5NZn3I9O96/55Qv
         Lu+4OY9GDDy4uYp4H/L9v0F7tsjmyp4FiI74NQisfm6IExm7oPeCI9w/jmnSz7f9IURg
         CLDQ==
X-Gm-Message-State: APjAAAXUXP8XQj80/HZe2Iy/bjmMCrDClrBxZDv5IBxyT40vgTYvzk9K
        D0Ip3EeNTSWMAEKh1Sb8+DVDCg==
X-Google-Smtp-Source: APXvYqyo5htStvL4GUlzhgjFEsdQ/OqafstBEi1svwlr0BrPR5qEWxUgYydeuZeFG5f69sAM8lJmJQ==
X-Received: by 2002:a67:2ed4:: with SMTP id u203mr36757368vsu.150.1559073325369;
        Tue, 28 May 2019 12:55:25 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o66sm8585579vke.17.2019.05.28.12.55.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 12:55:25 -0700 (PDT)
Date:   Tue, 28 May 2019 12:55:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org, f.fainelli@gmail.com
Subject: Re: [patch net-next v2 4/7] devlink: allow driver to update
 progress of flash update
Message-ID: <20190528125521.08912084@cakuba.netronome.com>
In-Reply-To: <20190528114846.1983-5-jiri@resnulli.us>
References: <20190528114846.1983-1-jiri@resnulli.us>
        <20190528114846.1983-5-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 May 2019 13:48:43 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Introduce a function to be called from drivers during flash. It sends
> notification to userspace about flash update progress.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
