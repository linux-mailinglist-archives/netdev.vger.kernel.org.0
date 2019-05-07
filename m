Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77A0156D7
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 02:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfEGAL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 20:11:29 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:46222 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfEGAL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 20:11:29 -0400
Received: by mail-qt1-f169.google.com with SMTP id i31so17013160qti.13
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 17:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3OcbdxQ8TsKNSWJbwv85U/GvGV9mG3QDRBy/O/j0bDE=;
        b=JXFso4JHkcswIWCGEfipIdttROJlExLEwoH80JbWG74V8v+HbzxVoaH8EppO/WhSC4
         6eIZsZ1z+qB8o4xzPI2zm+jZ/EQJMXIgP/p02+MGx0xpvytY/vlhtldnUonJTPSbCm+l
         z9l2T3/AKlNjDqmPROBfZTm0KQtKPgGtyUmO2VlRsZ8wgCO/aZWHtoATGwgbUAIo80av
         hXOUIfkJDTdyqrEWw9HlT1xWA9tmMj7uu/kf9Dra43SrEKpc7ei/xGHg5vjcL4vF+RZ4
         j/FLrZYFMcJDZ9VH6YpbD/9y1el1z79MjfgF1IWLOjsbBUhnfXdz/e9vOIFzXxm0LrSU
         vbnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3OcbdxQ8TsKNSWJbwv85U/GvGV9mG3QDRBy/O/j0bDE=;
        b=fzUn3EPIKi86jH+yjBicIVIgVT6/inozhH5T2AOzDo5zreZPXG4zoLG6bBxQSa2pvb
         T6d7fVGO+RUjG04rU5DIYMHOnHeePkwd8B4BBrKpKfGmMASu+zloka10NNZTFmx5KI8Y
         UjEPpoafban4KamW3bMkcb3l4YNclPLkkbHv7xjwgRftEy/sJPYWWIbXE2FXObnEHxXu
         zQNTjOKmFgpm4BmUtWDWYXOzCdNB9cZU1YLT09h8wfPsmoVa5FNY2pEBaD1ZWdfH+Zp5
         JKf47Vu40gSSAwrWKyxwKl0QsIdkxKa/ji7G7R3k+v5drlCM4NAWG1Z2CDezgXK+qqnr
         oiow==
X-Gm-Message-State: APjAAAWLcKqDY7jcWf6Pl4NOwqDOe7kSlZ3oj5cJ+/GCnL83iLaFtWfp
        od2Rwl1fxGGvDDjh63M7EeXVHQ==
X-Google-Smtp-Source: APXvYqwsVk/fW7/2riwiQyl6P4DeQbHZWViT2n/+PaHa5VA/lEDvn024YdlcOgeXvTe3nmxebsxv0g==
X-Received: by 2002:ac8:2556:: with SMTP id 22mr25131743qtn.356.1557187888193;
        Mon, 06 May 2019 17:11:28 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v14sm822086qkj.51.2019.05.06.17.11.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 06 May 2019 17:11:28 -0700 (PDT)
Date:   Mon, 6 May 2019 17:11:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net-next 09/15] net/mlx5: Create FW devlink health reporter
Message-ID: <20190506171122.5ea54733@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20190505003207.1353-10-saeedm@mellanox.com>
References: <20190505003207.1353-1-saeedm@mellanox.com>
        <20190505003207.1353-10-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 May 2019 00:33:23 +0000, Saeed Mahameed wrote:
> From: Moshe Shemesh <moshe@mellanox.com>
> 
> Create mlx5_devlink_health_reporter for FW reporter. The FW reporter
> implements devlink_health_reporter diagnose callback.
> 
> The fw reporter diagnose command can be triggered any time by the user
> to check current fw status.
> In healthy status, it will return clear syndrome. Otherwise it will dump
> the health info buffer.
> 
> Command example and output on healthy status:
> $ devlink health diagnose pci/0000:82:00.0 reporter fw
> Syndrome: 0
> 
> Command example and output on non healthy status:
> $ devlink health diagnose pci/0000:82:00.0 reporter fw
> diagnose data:
> assert_var[0] 0xfc3fc043
> assert_var[1] 0x0001b41c
> assert_var[2] 0x00000000
> assert_var[3] 0x00000000
> assert_var[4] 0x00000000
> assert_exit_ptr 0x008033b4
> assert_callra 0x0080365c
> fw_ver 16.24.1000

Does FW version really have to be duplicated in this API?

> hw_id 0x0000020d
> irisc_index 0
> synd 0x8: unrecoverable hardware error
> ext_synd 0x003d
> raw fw_ver 0x101803e8
