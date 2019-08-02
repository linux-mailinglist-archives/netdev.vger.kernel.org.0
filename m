Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F1F8003D
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 20:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405999AbfHBSfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 14:35:41 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:16913 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405984AbfHBSfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 14:35:41 -0400
Received: (qmail 68070 invoked by uid 89); 2 Aug 2019 18:29:01 -0000
Received: from unknown (HELO ?172.20.175.84?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4z) (POLARISLOCAL)  
  by smtp2.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 2 Aug 2019 18:29:01 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, bruce.richardson@intel.com,
        songliubraving@fb.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 2/2] xsk: support BPF_EXIST and BPF_NOEXIST
 flags in XSKMAP
Date:   Fri, 02 Aug 2019 11:28:56 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <26421FA3-6C40-4E6F-A320-105D35D858B6@flugsvamp.com>
In-Reply-To: <20190802081154.30962-3-bjorn.topel@gmail.com>
References: <20190802081154.30962-1-bjorn.topel@gmail.com>
 <20190802081154.30962-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2 Aug 2019, at 1:11, Björn Töpel wrote:

> From: Björn Töpel <bjorn.topel@intel.com>
>
> The XSKMAP did not honor the BPF_EXIST/BPF_NOEXIST flags when updating
> an entry. This patch addresses that.
>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Reviewed-by: Jonathan Lemon <jonathan.lemon@gmail.com>
