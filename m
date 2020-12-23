Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D361D2E208A
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgLWSno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbgLWSnn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 13:43:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F28217A0;
        Wed, 23 Dec 2020 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608748983;
        bh=WPbRJB31OoyYlojjavY8RSfb0uh0xBc50aEW+7aL9Bw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MihaWJSphTju1DnAWO98LYNc/7kcK3rLq1mKpyO5juS83uAGGiFyTkQuEBeY9/+9R
         6Unu+TARTeAtqM8KFQYYh+iKeEDGzZUrVKMecklWL9ga8S/D6fxYL8kRBgfSL5khz0
         5DVh785H7RGuSg7k/mEh2RxDIyHNd26jMhR9GNsmlwXlgIl0+ElVIYgD5dulCW7eBf
         20WFnMVcncbsupTF1+pBgBkGEoieGaFX+u4S6gfpCQpJzgxXryLJZXlEGgRIU70Zwo
         K3jz7ZR4PIz9APGAOaD78CjLwf48MhVWpBDX5GFpbnWjP7CmiGGJXe5p+GiLHchbSc
         yvI/4x4HJC10w==
Date:   Wed, 23 Dec 2020 10:43:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: qcom,ipa: Drop unnecessary type ref
 on 'memory-region'
Message-ID: <20201223104301.2c8cea22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201222040121.1314370-1-robh@kernel.org>
References: <20201222040121.1314370-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Dec 2020 21:01:21 -0700 Rob Herring wrote:
> 'memory-region' is a common property, so it doesn't need a type ref here.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Alex Elder <elder@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>

Acked-by: Jakub Kicinski <kuba@kernel.org>
