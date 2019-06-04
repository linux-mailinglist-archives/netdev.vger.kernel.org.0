Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B55234D09
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 18:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfFDQPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 12:15:38 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:55649 "EHLO
        cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbfFDQPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 12:15:38 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50])
        by cassarossa.samfundet.no with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sesse@samfundet.no>)
        id 1hYC62-0004RG-Gf; Tue, 04 Jun 2019 18:15:35 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.92)
        (envelope-from <sesse@samfundet.no>)
        id 1hYC62-0008TC-81; Tue, 04 Jun 2019 18:15:34 +0200
Date:   Tue, 4 Jun 2019 18:15:34 +0200
From:   "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc:     netdev@vger.kernel.org
Subject: Re: EoGRE sends undersized frames without padding
Message-ID: <20190604161534.53rvelboylu22uov@sesse.net>
References: <20190530083508.i52z5u25f2o7yigu@sesse.net>
 <20190530223832.kwoh4yvbbftl4vwc@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190530223832.kwoh4yvbbftl4vwc@sesse.net>
X-Operating-System: Linux 5.1.2 on a x86_64
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 12:38:32AM +0200, Steinar H. Gunderson wrote:
> As a proof of concept (no error handling, probably poor performance, not
> implemented for IPv6, other issues?), this patch works and fixes my problem:

Hi,

Any comments on this?

/* Steinar */
-- 
Homepage: https://www.sesse.net/
