Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF386149DF7
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 01:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgA0AS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 19:18:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:53068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgA0AS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 19:18:27 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BB142071E;
        Mon, 27 Jan 2020 00:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580084307;
        bh=q6Dl0Sf4Ztk5PBdg5J98RukLvgf6Y4nzkhe2PKbMOPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H+fb82Z3eoMeHKeJZYnL6FTiQC22Jp9MMHEHYFcKdny+JXgFCYSs2a8ZQIg16UwZy
         qyyFoUsclrR5GOS8kFTCnfRnSg/dncF6mih3qsL4BVyHxXbI5ltFqNp/t6NCl+4abk
         R/ho9Y9o3fc/BNHn/ocAVd+GsfbyX1WM0wYprJjw=
Date:   Sun, 26 Jan 2020 16:18:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 14/16] devlink: add macros for "fw.roce" and
 "board.nvm_cfg"
Message-ID: <20200126161826.0e4df544@cakuba>
In-Reply-To: <1580029390-32760-15-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
        <1580029390-32760-15-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jan 2020 04:03:08 -0500, Michael Chan wrote:
> --- a/Documentation/networking/devlink/devlink-info.rst
> +++ b/Documentation/networking/devlink/devlink-info.rst
> @@ -59,6 +59,11 @@ board.manufacture
>  
>  An identifier of the company or the facility which produced the part.
>  
> +board.nvm_cfg
> +-------------
> +
> +Non-volatile memory version of the board.

Could you describe a little more detail? Sounds a little similar to
fw.psid which Mellanox has added, perhaps it serves the same purpose
and we could reuse that one?
