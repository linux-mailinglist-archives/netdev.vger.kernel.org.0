Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249B44383F2
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 16:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhJWOfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 10:35:04 -0400
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:44786 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230463AbhJWOfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 10:35:03 -0400
Received: from omf14.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 9FE0518121430;
        Sat, 23 Oct 2021 14:32:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf14.hostedemail.com (Postfix) with ESMTPA id A27E8268E45;
        Sat, 23 Oct 2021 14:32:42 +0000 (UTC)
Message-ID: <68b50f515daf367097b7285b533d60ba5f6ff186.camel@perches.com>
Subject: Re: [PATCH net-next 0/2] Small fixes for true expression checks
From:   Joe Perches <joe@perches.com>
To:     =?UTF-8?Q?J=CE=B5an?= Sacren <sakiwit@gmail.com>,
        Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Date:   Sat, 23 Oct 2021 07:32:41 -0700
In-Reply-To: <cover.1634974124.git.sakiwit@gmail.com>
References: <cover.1634974124.git.sakiwit@gmail.com>
         <cover.1634974124.git.sakiwit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A27E8268E45
X-Spam-Status: No, score=-0.98
X-Stat-Signature: kzz4kbd37mtf8y568qiydypwbrkiczo6
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+e/ZwRxjWXim6jhgAVej5NQ23loRCp+NY=
X-HE-Tag: 1634999562-517678
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-10-23 at 03:26 -0600, Jεan Sacren wrote:
> This series fixes checks of true !rc expression.

Found by inspection or tool?


