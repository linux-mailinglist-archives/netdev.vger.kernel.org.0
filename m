Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB285027D
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 08:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfFXGpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 02:45:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45500 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFXGpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 02:45:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AJNWEGJIKDd3zy48iUOMkrDN5zu/iHSPzKernfVg8M8=; b=Mh/q5FnmR+faF/a1V6A+X8EvQ
        9PpQ4CXlMiYqtpivjYKYu5VGfA+EPMiFUA+9ct8EZggQVj3Gx+gvadUnoPHu+C7Yd+UVO204L51bu
        xx/9SKwJ1iDnT2CkEBsIM1nUj5kJX7nctb5hDvh3VUZ9RT60LS5HBf+RN62YUapKbMZPiJiI3GSP4
        eAgJ5t5b2aBV6zaJtcDm5IN6N0nSKvlil5mMq0/adXULOD9ooY9SjukG+p73pMj/qbkMqz+XRPRwD
        H2NA5jbZmfso9Tt/SmXJHXYsxNI6AwejnN2q8wRST0C6dtzXrssDtD+/OsNmvsrl+9BwBObQ4BUEe
        wOlPUMTqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfIjZ-0002lV-8p; Mon, 24 Jun 2019 06:45:45 +0000
Date:   Sun, 23 Jun 2019 23:45:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Puranjay Mohan <puranjay12@gmail.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 1/3] net: fddi: skfp: Rename PCI_REV_ID to
 PCI_REVISION_ID
Message-ID: <20190624064545.GA23977@infradead.org>
References: <20190620180754.15413-1-puranjay12@gmail.com>
 <20190620180754.15413-2-puranjay12@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620180754.15413-2-puranjay12@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 11:37:52PM +0530, Puranjay Mohan wrote:
> Rename the PCI_REV_ID define to PCI_REVISION_ID in skfbi.h
> and drvfbi.c to make it compatible with the pci_regs.h
> which defines it as PCI_REVISION_ID.

We already cache the revision in struct pci_dev.  In doubt you should
use that one.
