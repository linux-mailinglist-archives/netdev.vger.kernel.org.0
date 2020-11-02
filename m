Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F31A2A36EE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgKBXHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgKBXHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:07:34 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DA502225E;
        Mon,  2 Nov 2020 23:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604358454;
        bh=eE1wfkYKnsfHbpK9kIz/M6a+fpspsbLlOWGMQxHY1+4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BGduIqyT7OTQmu+BBlyMGPFyEV8DfjQMoWsoVwu6/VXHdRjfQZ2vo0uSKJdnzHq3j
         D2Hylh2KdbEi+sNAv8tTQCvff3ntcoS4ejpCQ1NbB2Z+F7fYwgNkhRA1zvFg2DllsR
         1upS0TbzJW0EkjkyblkJEOF3SHQpE7QbRgyark/U=
Message-ID: <be6ac7df8079164d8e9cb42e381799629a4479fb.camel@kernel.org>
Subject: Re: [net-next 14/15] ice: join format strings to same line as
 ice_debug
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, Aaron Brown <aaron.f.brown@intel.com>
Date:   Mon, 02 Nov 2020 15:07:32 -0800
In-Reply-To: <20201102222338.1442081-15-anthony.l.nguyen@intel.com>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
         <20201102222338.1442081-15-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-02 at 14:23 -0800, Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> When printing messages with ice_debug, align the printed string to
> the
> origin line of the message in order to ease debugging and tracking
> messages back to their source.
> 

Just out of curiosity, you are only re-aligning the code and not the
printed messages themselves. How would this help ? did you mean help
with tracking the sources when doing grep like operations on the source
code ? 



