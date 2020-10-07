Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E85F286942
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgJGUkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727776AbgJGUkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 16:40:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44BB820760;
        Wed,  7 Oct 2020 20:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602103200;
        bh=1teXlFJSHxSnmTaH/K3X7/nHgTIRkwQVbstB4J+5qF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z9Cb+Jt7oQGDhNQr952LIKNPRfkm93a3v1SFcMfwdabZSEkOfl/kmdTncyQhxGPPV
         xjkionQ0HhZIttU+MOIWYYqwl1K09nb1ds0DOsZjIc/4mFXDeacXNl83PUNUKMwj+W
         cAbqydqXabXLTpvfMLPLaMC12ku3MZLOtkS+xBn4=
Date:   Wed, 7 Oct 2020 13:39:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next 0/8][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-10-07
Message-ID: <20201007133958.43452ce7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
References: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 10:54:39 -0700 Tony Nguyen wrote:
> This series contains updates to ice driver only.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
