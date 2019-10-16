Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DA8D85B4
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 04:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389317AbfJPCFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 22:05:06 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41183 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfJPCFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 22:05:05 -0400
Received: by mail-pg1-f193.google.com with SMTP id t3so13277064pga.8
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 19:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QC3gEZR1hPeoV9cErrVTRBwhQgxMJw1kOt/RcyP6C6w=;
        b=1w0IOtYfvSoz2t35HiCfmWEBG/6NZWQDRGyT9mxsztX6Py9Chwl0498ydNjJh0c//p
         /pUv8LxQNVibIrycGvKocjulsnsWN/vrTMaIcY1fIUvc31ZU4qCJbyuLdDBntXMOE97d
         CyZP6VcCp7aR21Vyf109i5U2fhry6UYaMZg/lPZnzoxThrZk2aILiB6YLGoeDlXfwUCp
         WZ55aOfZvtWNYwrk3OErtEE+rJS+BVioCM6nZOf2QnanyzFj9ftGRv/hZAkzpU6ZzsaG
         hnJoKhQL2U4Vq2icAfQqb45uaJqw1uM7uoNVkHL4LUEWI48WHdO77tRksqhZaU97DX4U
         8dTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QC3gEZR1hPeoV9cErrVTRBwhQgxMJw1kOt/RcyP6C6w=;
        b=FZYbAxvdTTLQW+g7/HihbVmbCwe6cSi+4Pyqn9aNZHBKtCEC9Mtm7/fP5uAEMs+G3Q
         ZI+ioXpgbS9L7iABtEXlJdFYNstSuogcxpjcZY1mmqWr+yKJl+U2YtlGT/PIf1RQ7WBi
         VMOVN64qY7cLgeU7oSIjKvzXkHQSvHi5Fwvb/cbBVs8h4GXjBl/Ub9fxGDrsufM2E+C4
         fB3PEgdI9ro3mw8QN5BVBeB8ObV8pm9zObF0bsTIrGD18Y3hJRzKKAi9wfe2q/6np/ba
         PRaktijSFfEww6vsyOlBcMVICNywlyYE1wcryABqimcW6aIbYNAh6ODmd8h+27kmuEwg
         FybA==
X-Gm-Message-State: APjAAAV5ObN1aMFhaHeNRRQ5oqzl6ICjD4Pwsj3PgYY7doYvP/QJVtpW
        9i+VkKJx1ZqTzcT+QM0oLQPpVw==
X-Google-Smtp-Source: APXvYqw/EikbC+SU1Dgo4BMgqr5G5Xrl3P4spbJU2PEsTCnZX+e9JRuffgAYMJbGXbmsMOTX3yMNyA==
X-Received: by 2002:a63:3c3:: with SMTP id 186mr22567709pgd.285.1571191502725;
        Tue, 15 Oct 2019 19:05:02 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 16sm21264196pfn.35.2019.10.15.19.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 19:05:02 -0700 (PDT)
Date:   Tue, 15 Oct 2019 19:04:55 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com, tiwei.bie@intel.com,
        jason.zeng@intel.com, zhiyuan.lv@intel.com
Subject: Re: [RFC 1/2] vhost: IFC VF hardware operation layer
Message-ID: <20191015190455.0d79b836@hermes.lan>
In-Reply-To: <20191016010318.3199-2-lingshan.zhu@intel.com>
References: <20191016010318.3199-1-lingshan.zhu@intel.com>
        <20191016010318.3199-2-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 09:03:17 +0800
Zhu Lingshan <lingshan.zhu@intel.com> wrote:

> +int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *dev)
> +{
> +	int ret;
> +	u8 pos;
> +	struct virtio_pci_cap cap;
> +	u32 i;
> +	u16 notify_off;

For network code, the preferred declaration style is
reverse christmas tree.
