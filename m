Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF2318DB0E
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 23:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgCTWVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 18:21:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:38060 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbgCTWVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 18:21:23 -0400
IronPort-SDR: 8rqSX3rc6kDaBheJFdKRydKQp9H7bpN24NDytN4I5LsS4VFqVIeaY4H7pkdJnF88Xiway9LopT
 CUiAlHziKzTQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 15:21:22 -0700
IronPort-SDR: 8Ay6OQxM+aILuohwi5ORMLfN3w5f887NOv1ojbguFUvGwTwX9PAZ6JU58Sua45GXWFrKCgK66r
 0P58aLXfrSBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="445126035"
Received: from mnyman-mobl.ger.corp.intel.com (HELO localhost) ([10.249.32.33])
  by fmsmga005.fm.intel.com with ESMTP; 20 Mar 2020 15:21:15 -0700
Date:   Sat, 21 Mar 2020 00:21:13 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Waiman Long <longman@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Chris von Recklinghausen <crecklin@redhat.com>
Subject: Re: [PATCH v6 2/2] KEYS: Avoid false positive ENOMEM error on key
 read
Message-ID: <20200320222113.GB5284@linux.intel.com>
References: <20200320191903.19494-1-longman@redhat.com>
 <20200320191903.19494-3-longman@redhat.com>
 <20200320221918.GA5284@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320221918.GA5284@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 12:19:27AM +0200, Jarkko Sakkinen wrote:
> Would move this label before condition instead of jumping inside the
> nested block since it will always evaluate correctly.
> 
> To this version haven't really gotten why you don't use a legit loop
> construct but instead jump from one random nested location to another
> random nested location? This construct will be somewhat nasty to
> maintain. The construct is weird enough that you should have rather
> good explanation in the long description why such a mess.

What I'm saying that if I fix a bug, the first version of the fix
would probably look something like this is right now. They I think
how to write it right. We don't want fixes that just happen to work.
Right now I'm worried to take this in since I'm not confident that
I haven't some possible corner case, or might still have gotten
something just plain wrong.

/Jarkko
