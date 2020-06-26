Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEB820B1A4
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 14:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgFZMpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 08:45:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:5731 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbgFZMpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 08:45:54 -0400
IronPort-SDR: wogu91YRuYXc07DCdw/F3vnw8kEY/P7RUbKZNROzFd/l0xAHbp/1hoDmjBTPgtYFIgJ5owAWO8
 m3jtaw4oELGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="230079600"
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="230079600"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 05:45:53 -0700
IronPort-SDR: VaD1q6TtXI94Yn3AmDSxJ/Gddk74kZx77Zx8AEtZRsBHt07WwpbqTFOvtTAQEmpKus8H3E60wH
 dYbBo1RcKFqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,283,1589266800"; 
   d="scan'208";a="301117987"
Received: from swallace-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.52.84])
  by orsmga007.jf.intel.com with ESMTP; 26 Jun 2020 05:45:50 -0700
Subject: Re: the XSK buffer pool needs be to reverted
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        bpf <bpf@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
References: <20200626074725.GA21790@lst.de>
 <f1512c3e-79eb-ba75-6f38-ca09795973c1@intel.com>
 <20200626124104.GA8835@lst.de>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <f049b82a-4c69-c021-8988-78d757169247@intel.com>
Date:   Fri, 26 Jun 2020 14:45:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200626124104.GA8835@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-26 14:41, Christoph Hellwig wrote:
> On Fri, Jun 26, 2020 at 02:22:41PM +0200, Björn Töpel wrote:
[...]
>>
>> Understood. Wdyt about something in the lines of the diff below? It's
>> build tested only, but removes all non-dma API usage ("poking
>> internals"). Would that be a way forward, and then as a next step work
>> on a solution that would give similar benefits, but something that would
>> live in the dma mapping core?
> 
> Yes, that would solve the immediate issues.
> 

Good. I'll cook a proper patch and post it.


Björn
