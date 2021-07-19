Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBB03CD194
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhGSJ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 05:29:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235355AbhGSJ3S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 05:29:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C772610FB;
        Mon, 19 Jul 2021 10:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626689398;
        bh=p4u49T6z3X2BSG2iSwf12rRjrPPy7HxDT8HC3zK38Uw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uws4aobYtQ07DqnmNLJ+Jxz191ULcG0/gIjvVLrahBn/RhE87o7MLhtxMB3SQJQTl
         O4JAFV+GuMjMMc1ns/jzYdpjKamyvX+47lSxdh7oWccAsJfLT4GBl8cB2KGuITdQiA
         KK5tZjn2IdQWsroEDoH7I2hfP6v0chLQNMvVibDpYYpQlOb1HHlGzwnSrrNYPe/99y
         SfM4RRxltvSWxkr14gQ9C+5icO4Cd7RGrGiuIaRYDF243jCKGpO5jy6YPnxp9d1btT
         JvV2392vFBiI/ba3L+Rkrh3WrwS3Nl2xwNPH1Jf/Slu3QphmnrSXAnm2UrLne/rUZR
         uLzlFq/Sbf9XQ==
Date:   Mon, 19 Jul 2021 12:09:53 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ruud Bos <ruud.bos@hbkworld.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] igb: support PEROUT and EXTTS PTP pin
 functions on 82580/i354/i350
Message-ID: <20210719120918.44cb80cf@cakuba>
In-Reply-To: <AM0PR09MB4276D9CCEBD1400A884AFB06F0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
References: <AM0PR09MB4276D9CCEBD1400A884AFB06F0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 06:25:36 +0000, Ruud Bos wrote:
> The igb driver provides support for PEROUT and EXTTS pin functions that
> allow adapter external use of timing signals. At Hottinger Bruel & Kjaer we
> are using the PEROUT function to feed a PTP corrected 1pps signal into an
> FPGA as cross system synchronized time source.

Please resend and CC appropriate maintainers.
scripts/get_maintainers.pl should help.
