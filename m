Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBBE194BA3
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 23:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgCZWjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 18:39:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:38016 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCZWjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 18:39:21 -0400
IronPort-SDR: pCY1fiuoo2euyUVHn5pIXqYw8Ia/0puaW00Ta5r8CMQioDkeBfJ2UaacnershhzjvQHUz5kPQQ
 e9LXdMkPn2KQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 15:39:21 -0700
IronPort-SDR: CbGRbHx5FxUsTvFPh0ITjcnE0hZMIHPUuZ0/wEjbeMEYIezkBNz8AYlbvdktrD0OVjTSwJqngG
 8EF6qQZLjYnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="240804376"
Received: from alewando-mobl.ger.corp.intel.com ([10.252.40.24])
  by fmsmga008.fm.intel.com with ESMTP; 26 Mar 2020 15:39:15 -0700
Message-ID: <c3a91d6d572d4975a8a5d3dbf004e46d7f59be78.camel@linux.intel.com>
Subject: Re: [PATCH v8 0/2] KEYS: Read keys to internal buffer & then copy
 to userspace
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     David Howells <dhowells@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     longman@redhat.com, jmorris@namei.org, serge@hallyn.com,
        zohar@linux.ibm.com, kuba@kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, sumit.garg@linaro.org,
        jsnitsel@redhat.com, roberto.sassu@huawei.com, ebiggers@google.com,
        crecklin@redhat.com
In-Reply-To: <996368.1585246352@warthog.procyon.org.uk>
References: <20200325.193056.1153970692429454819.davem@davemloft.net>
         <20200322011125.24327-1-longman@redhat.com>
         <996368.1585246352@warthog.procyon.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160
 Espoo
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Fri, 27 Mar 2020 00:37:30 +0200
User-Agent: Evolution 3.35.92-1 
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-03-26 at 18:12 +0000, David Howells wrote:
> David Miller <davem@davemloft.net> wrote:
> 
> > Who will integrate these changes?
> 
> I'll do it unless Jarkko wants to push it through his tree.

Please do.

/Jarkko

