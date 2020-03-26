Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B7D194956
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgCZUka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbgCZUk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:40:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E5912070A;
        Thu, 26 Mar 2020 20:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585255227;
        bh=zphw5NiRIGdRIUxu63Iu1HosEOz7LKKDhAZ4OHJngDY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iJHbFv5N0ljQJ76gUy0L23/aR0Ur6JBG1HxknOGdEAC3PJ/DE+7aUj8awXd1gRBEo
         CUFkte9QMHrXB9zuWMGh3r3YMruXQNDNRhGxTjQJub70tsyjqtk4BBWAjOWiW9/Fhb
         OUP7l1gI4FCWt4fJK93QqDFvJ7xD52q+iHMYOTIw=
Date:   Thu, 26 Mar 2020 13:40:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v3 net-next 1/5] devlink: Add macro for "fw.api" to
 info_get cb.
Message-ID: <20200326134025.2c2c94f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1585224155-11612-2-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585224155-11612-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <1585224155-11612-2-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 17:32:34 +0530 Vasundhara Volam wrote:
> Add definition and documentation for the new generic info "fw.api".
> "fw.api" specifies the version of the software interfaces between
> driver and overall firmware.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
> v1->v2: Rename macro to "fw.api" from "drv.spec".

I suggested "fw.mgmt.api", like Intel has. What else those this API
number covers beyond management? Do you negotiated descriptor formats
for the datapath?
