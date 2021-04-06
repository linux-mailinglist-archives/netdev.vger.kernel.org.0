Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2221354C03
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 07:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242572AbhDFFIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 01:08:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232046AbhDFFIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 01:08:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19FC761399;
        Tue,  6 Apr 2021 05:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617685692;
        bh=yJAMPT3SLQmNKNC+4OsLfCTNj7400s3+w4dctPYKi7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vQCpEOc/VbD+dpJ48rlgSiUT6wRFeg+/NrHJ/98Ecy1B/DY7kv5o4EIY9tYpXeHmh
         dDmBpo8juNXVXiWF7yeBX1ka6mWJzsbGxmvjfYBqhLxVkjdaQ6ZowaiVn8L0qmVgPR
         teb6QH9HqZHmRDU8hI4ZQxU3HTQVDonuTgylinDUr8PG9J380zy0a1kTc6RSi8aEtN
         vH73NlCrZqyUZvj1l5NPg3fLkFWeHoenR6BJq4sQm8IL97uzoXQw0+9Sa1z2fMMekB
         WeG+kRx9P3VIHLkAyrjOUcKobiu+qyh4Q3SLN/yH/RO8GvnQSIZ9S73jYwtDWgGe1N
         EhWEDWmAKgcPA==
Date:   Tue, 6 Apr 2021 10:38:09 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH linux-next v2 1/1] phy: Sparx5 Eth SerDes: Use direct
 register operations
Message-ID: <YGvsuVMz54R5O7Eb@vkoul-mobl.Dlink>
References: <20210329141309.612459-1-steen.hegelund@microchip.com>
 <20210329141309.612459-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329141309.612459-2-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29-03-21, 16:13, Steen Hegelund wrote:
> Use direct register operations instead of a table of register
> information to lower the stack usage.

Applied, thanks

-- 
~Vinod
