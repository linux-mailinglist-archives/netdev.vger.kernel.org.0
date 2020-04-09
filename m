Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416E01A3AB4
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 21:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgDITmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 15:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:32904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgDITmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 15:42:22 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE0F120757;
        Thu,  9 Apr 2020 19:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586461343;
        bh=CgVYYauP2DS1zAGH2cABpu8SDA/vLEAf6b3yt8FcM1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T1T5GMItybfKn/tDwTgpefmzrhof0vgGDBhWCoN6zcPYMSXBU5cOW9OwAjQs2f4vm
         yTqX6t4r8t7l27mKOmcCQ3Fl+F4Nh+Nybo0OB1mqhQZwYY+/RtrpYmQzhmfuebCUpR
         Ju7bPj21pe129OKlBWeDzcnHgJ1ZGf7Y3mehi/bw=
Date:   Thu, 9 Apr 2020 12:42:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com
Subject: Re: [PATCH net] docs: networking: add full DIM API
Message-ID: <20200409124221.128d6327@kicinski-fedora-PC1C0HJN>
In-Reply-To: <e27192c8-a251-4d72-1102-85d250d50f49@infradead.org>
References: <20200409175704.305241-1-kuba@kernel.org>
        <fcda6033-a719-adfb-c25d-d562072b5e82@infradead.org>
        <e27192c8-a251-4d72-1102-85d250d50f49@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Apr 2020 12:27:17 -0700 Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Add the full net DIM API to the net_dim.rst file.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: davem@davemloft.net
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org, talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com

Ah, very nice, I didn't know how to do that!

Do you reckon we should drop the .. c:function and .. c:type marking I
added? So that the mentions of net_dim and the structures point to the
kdoc?

Do you want to take best parts of both your and my versions and repost?
