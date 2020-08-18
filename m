Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BC124901B
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgHRVam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 17:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgHRVal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 17:30:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E769206DA;
        Tue, 18 Aug 2020 21:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597786241;
        bh=fNcIAGDJzev4eRq6cUQs/UhGvYFK5iX6dQrgjN98FNQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TnNUHmdbIJVPavlugfqF8tw0NvBciyXjBttDnFSQnGVcLN53GZpwwMmwxbbFQKz/G
         zmJUvzcG169wbZXrlFuUrd/fM6JAXkE9wIogYsSbeHmxSROfU2oC3PDdY2sJNTqkpS
         37LGJqa16l/ODJJdByG2EmozRQ+qtxVnmhGaXz5g=
Date:   Tue, 18 Aug 2020 14:30:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next 08/18] gve: Enable Link Speed Reporting in the
 driver.
Message-ID: <20200818143039.0c74505b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818194417.2003932-9-awogbemila@google.com>
References: <20200818194417.2003932-1-awogbemila@google.com>
        <20200818194417.2003932-9-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 12:44:07 -0700 David Awogbemila wrote:
> This change allows the driver to report the device link speed
> when the ethtool command:
> 	ethtool <nic name>
> is run.
> Getting the link speed is done via a new admin queue command:
> ReportLinkSpeed.
> 
> Reviewed-by: Yangchun Fu <yangchun@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>

Please make sure the code builds cleanly with W=1 C=1:

drivers/net/ethernet/google/gve/gve_adminq.c:620:28: warning: cast to restricted __be64
drivers/net/ethernet/google/gve/gve_adminq.c:620:28: warning: cast to restricted __be64
drivers/net/ethernet/google/gve/gve_adminq.c:620:28: warning: cast to restricted __be64
drivers/net/ethernet/google/gve/gve_adminq.c:620:28: warning: cast to restricted __be64
drivers/net/ethernet/google/gve/gve_adminq.c:620:28: warning: cast to restricted __be64
drivers/net/ethernet/google/gve/gve_adminq.c:620:28: warning: cast to restricted __be64
drivers/net/ethernet/google/gve/gve_adminq.c:620:28: warning: cast to restricted __be64
drivers/net/ethernet/google/gve/gve_adminq.c:620:28: warning: cast to restricted __be64
drivers/net/ethernet/google/gve/gve_adminq.c:620:28: warning: cast to restricted __be64
drivers/net/ethernet/google/gve/gve_adminq.c:620:28: warning: cast to restricted __be64
