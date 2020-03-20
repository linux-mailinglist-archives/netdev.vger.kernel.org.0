Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B153B18C607
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 04:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCTDoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 23:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCTDoB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 23:44:01 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D83420724;
        Fri, 20 Mar 2020 03:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584675841;
        bh=W1Re1bei/9+HydLN0RQf26IbOv5FeO7jNrNB4G4r2aI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dHbgLkesBZWpy/c74O+oRvNbmItM4U/6/Pb5R/MaKW+EJqr9BUAYDK0ZbF/c570jv
         FKhaCaqvEKsMGb+8a1YKvZJEqqKIrtO/E8GdLZ7xrP8NkzG7fTwdPqPETXchuCvZtq
         phFG9T9QaENH3VwnSWICEuw83E4iXhSjQQShqs3Y=
Date:   Thu, 19 Mar 2020 20:43:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 4/6] ionic: ignore eexist on rx filter add
Message-ID: <20200319204358.7e141f1a@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200320023153.48655-5-snelson@pensando.io>
References: <20200320023153.48655-1-snelson@pensando.io>
        <20200320023153.48655-5-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Mar 2020 19:31:51 -0700 Shannon Nelson wrote:
> Don't worry if the rx filter add firmware request fails on
> EEXIST, at least we know the filter is there.  Same for
> the delete request, at least we know it isn't there.
> 
> Fixes: 2a654540be10 ("ionic: Add Rx filter and rx_mode ndo support")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Why could the filter be there? Seems like the FW shouldn't have filters
the driver didn't add, could a flush/reset command help to start from
clean state?

Just curious.
