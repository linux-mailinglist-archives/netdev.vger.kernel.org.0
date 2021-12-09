Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5752C46EBFC
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbhLIPpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236319AbhLIPpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 10:45:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8930DC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 07:42:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FA4FB82489
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 15:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBA3C004DD;
        Thu,  9 Dec 2021 15:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639064526;
        bh=/+HWbShjHhMbtHCcfcfdY8s1GSClm59MVQiiQeLE3NE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EV4qrPk9qzOGiTKKafbUOoaDK5TMXnlm1N2L/k6dBOb/l0hkVGLf1vbakwdvEmpxU
         XTTMRo0EFplPEZyWBcXttldBRMJphO2X9QrlhtUaNPU2+NkQJu2NEXa5dOQalA/J+X
         3vSUm1q//UIB1svSgNkwb9HIQB7AtE9QZSwdARZPhUKhf1GAoNK6dz8oEra8fM1koM
         NRDDXbv8fLCVCaOTBqObfIIq5dQcEdTGurIFmn6jxNKEg/p53kXJRS0vMhZPHpYXjB
         abqdl806xLcZJPYraY1Alf7CeCf4XpOUIDoJpxYCPx9xY15HBMb31y/yYGaGZwjJ7I
         R2xsY/rSvDPGw==
Date:   Thu, 9 Dec 2021 07:42:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Lamparter <equinox@diac24.net>
Cc:     netdev@vger.kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: Re: [PATCH] bridge: extend BR_ISOLATE to full split-horizon
Message-ID: <20211209074204.4be34975@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211209121432.473979-1-equinox@diac24.net>
References: <20211209121432.473979-1-equinox@diac24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Dec 2021 13:14:32 +0100 David Lamparter wrote:
> Split-horizon essentially just means being able to create multiple
> groups of isolated ports that are isolated within the group, but not
> with respect to each other.
> 
> The intent is very different, while isolation is a policy feature,
> split-horizon is intended to provide functional "multiple member ports
> are treated as one for loop avoidance."  But it boils down to the same
> thing in the end.
> 
> Signed-off-by: David Lamparter <equinox@diac24.net>
> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
> Cc: Alexandra Winter <wintera@linux.ibm.com>

Does not apply to net-next, you'll need to repost even if the code is
good. Please put [PATCH net-next] in the subject.
