Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D250C17995A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 20:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387912AbgCDTyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 14:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbgCDTyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 14:54:23 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5744A21556;
        Wed,  4 Mar 2020 19:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583351662;
        bh=WHj6lGOXLNcIDkx994shKOmfu7HnY6J6pmz3AuIu4C8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U/cKz+xu5A26HHtX1pzvGKRf7MlDC0+wqvuBwee7sOtPf0l9H2rQc2cV/rvktG1nh
         wgo1C5LwaWajJmjF2lq1j/5j+moNpT1/OOmL6ue6xH+o6f3LaKFpT4J4HTm1b+NRDh
         FPn819GUkRqrnGGNqFJAmC2cKKxemEqD6GMhvqpk=
Date:   Wed, 4 Mar 2020 11:54:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/8] ionic: remove pragma packed
Message-ID: <20200304115420.2824655b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200304042013.51970-3-snelson@pensando.io>
References: <20200304042013.51970-1-snelson@pensando.io>
        <20200304042013.51970-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Mar 2020 20:20:07 -0800 Shannon Nelson wrote:
> Replace the misguided "#pragma packed" with tags on each
> struct/union definition that actually needs it.  This is safer
> and more efficient on the various compilers and architectures.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Ah, I think I missed this pragma in original review :S

nit: I think __packed is preferred
