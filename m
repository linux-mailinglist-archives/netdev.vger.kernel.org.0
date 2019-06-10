Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3943BDE7
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 22:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389472AbfFJU45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 16:56:57 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:34948 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388135AbfFJU45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 16:56:57 -0400
Received: (qmail 34735 invoked by uid 89); 10 Jun 2019 20:56:55 -0000
Received: from unknown (HELO ?172.20.174.171?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4y) (POLARISLOCAL)  
  by smtp3.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 10 Jun 2019 20:56:55 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Ilya Maximets" <i.maximets@samsung.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf] xdp: check device pointer before clearing
Date:   Mon, 10 Jun 2019 13:56:49 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <76A4186A-5495-4003-A494-7DE0B15EFB1A@flugsvamp.com>
In-Reply-To: <20190607172732.4710-1-i.maximets@samsung.com>
References: <CGME20190607172737eucas1p28508d5e198907695bc77f9fd18ce233e@eucas1p2.samsung.com>
 <20190607172732.4710-1-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7 Jun 2019, at 10:27, Ilya Maximets wrote:

> We should not call 'ndo_bpf()' or 'dev_put()' with NULL argument.
>
> Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and 
> zero-copy on one queue id")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
