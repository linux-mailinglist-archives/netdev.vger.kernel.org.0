Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD8A64F27
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 01:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfGJXPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 19:15:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:55802 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbfGJXPk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 19:15:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 16:14:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,476,1557212400"; 
   d="scan'208";a="159900747"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.137])
  by orsmga008.jf.intel.com with ESMTP; 10 Jul 2019 16:14:39 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 209D23019F7; Wed, 10 Jul 2019 16:14:39 -0700 (PDT)
Date:   Wed, 10 Jul 2019 16:14:39 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Paolo Pisati <p.pisati@gmail.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [RESEND] test_verifier #13 fails on arm64: "retval 65507 != -29"
Message-ID: <20190710231439.GD32439@tassilo.jf.intel.com>
References: <20190701115414.GA4452@harukaze>
 <68248069-bcf6-69dd-b0a9-f4ec11e50092@fb.com>
 <20190710100248.GA32281@harukaze>
 <CAEf4BzayQ+bEKFHcs8cUDcVnwPpQ2_2gzPaxX-j38r=AWDzVvg@mail.gmail.com>
 <CAEf4Bzbtpqk-9ELnHFsHo278b5T4Z-2CgNnNbOqbD5Ocbuc-fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbtpqk-9ELnHFsHo278b5T4Z-2CgNnNbOqbD5Ocbuc-fg@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Reading csum_partial/csum_fold, seems like after calculation of
> > checksum (so-called unfolded checksum), it is supposed to be passed
> > into csum_fold() to convert it into 16-bit one and invert.

Yes, you always need to fold at the end.

The low level code does fold sometimes, but not always.

-Andi
