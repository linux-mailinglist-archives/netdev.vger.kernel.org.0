Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5233AC72F
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhFRJQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:16:29 -0400
Received: from ivanoab7.miniserver.com ([37.128.132.42]:49944 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbhFRJQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:16:26 -0400
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@kot-begemot.co.uk>)
        id 1luAZq-0006gy-HD
        for netdev@vger.kernel.org; Fri, 18 Jun 2021 09:14:14 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@kot-begemot.co.uk>)
        id 1luAZn-0003hR-UW
        for netdev@vger.kernel.org; Fri, 18 Jun 2021 10:14:14 +0100
To:     netdev@vger.kernel.org
From:   Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
Subject: NULL pointer dereference in libbpf
Message-ID: <6f6476fb-4b02-e543-6dad-aca3f9b5881c@kot-begemot.co.uk>
Date:   Fri, 18 Jun 2021 10:14:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

https://elixir.bootlin.com/linux/latest/source/tools/lib/bpf/bpf.c#L91

A string is copied to a pointer destination which has been memset to zero a few lines above.

Brgds,

-- 
Anton R. Ivanov
https://www.kot-begemot.co.uk/

