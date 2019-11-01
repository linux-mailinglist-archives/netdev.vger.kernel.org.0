Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7551BEBB6B
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 01:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfKAAXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 20:23:41 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38807 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbfKAAXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 20:23:41 -0400
Received: by mail-lj1-f193.google.com with SMTP id y23so8117358ljc.5
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 17:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=sL4GAHx0bYj95x00UNMaknbt113gLy6i5IBydur3AjE=;
        b=CB+0kqHpx6vn07m1hau5q0NiGMPU79nKRHSIDnTXfYSixe2Rcf6/F1XUqvBR6ET45s
         8HscjNLIycf/T0cenKdNYc+e+IOZy7DSG6kzGlJWgM/kR1u89YCnnWVr7EhcJy1AAZzo
         kd/vqVz20j96bYdcXWQv+rX7ueqILaqEfbo9zk5jSr7l5+jiT4xDd7B3NKNenCUPNcyc
         KRWDv319wUEy81z47CNJhZNzrwp/TNcpxQcEPtGwNdC1mORKdXtetooXEDbTTrqdl5Cf
         grX8f6kvlJ59/idaPO23IIDARvCZziZ8RwfFQXWsNsoXSTgCBUMq9He/uhZGECxae/uE
         nVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=sL4GAHx0bYj95x00UNMaknbt113gLy6i5IBydur3AjE=;
        b=ReMZ/uZrEnetoOjhOL2eXMNRCFu8H9imXWPz2IKc4C/11UDzztgGhGQJ7SLqOpsCV3
         E+3lqhMOZGB3K5BKSzCcP4TdmxEvqH/WXHWbgPH49oPiSPpMHBepZ+WSNFJtDASMg/D5
         gZMxSaIItbm0l2FEe0yYVZ9zObGA8I614fGbzXvILLbNICmj5/t7j0mHCtG9Os8s8UgV
         cYNg3mbnNPL1YOifxEDH9vBsgQ8rbMxfoFK0EvuGnZ5Tzwh58QvR/jjKcu8I4VkYvkTL
         fg4uUOuu1RvX6JroTec+4D7ux42wBKfNH9iS9T3ikMVf298X/kfdkRnZ9XSwnfUM8ifo
         av6w==
X-Gm-Message-State: APjAAAWNtnzsi1fYCa3zALFqQ94JfmdwDpF3YXUpBd0uqCgVDT2Gib00
        AgoGAYHET3C7H21j/slw/3oOnw==
X-Google-Smtp-Source: APXvYqwa44wIl0o4bL/wQhZSlq8K85XkTZ81HeSjxF1wxV1C4qzfXQrThWvqZ9/+BjzHUnFzwZMyeQ==
X-Received: by 2002:a2e:8555:: with SMTP id u21mr6087959ljj.252.1572567819474;
        Thu, 31 Oct 2019 17:23:39 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d28sm2068900lfn.33.2019.10.31.17.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 17:23:39 -0700 (PDT)
Date:   Thu, 31 Oct 2019 17:23:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ariel Levkovich <lariel@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Message-ID: <20191031172330.58c8631a@cakuba.netronome.com>
In-Reply-To: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 19:47:25 +0000, Ariel Levkovich wrote:
> The following series introduces VGT+ support for SRIOV vf
> devices.
> 
> VGT+ is an extention of the VGT (Virtual Guest Tagging)
> where the guest is in charge of vlan tagging the packets
> only with VGT+ the admin can limit the allowed vlan ids
> the guest can use to a specific vlan trunk list.
> 
> The patches introduce the API for admin users to set and
> query these vlan trunk lists on the vfs using netlink
> commands.
> 
> changes from v1 to v2:
> - Fixed indentation of RTEXT_FILTER_SKIP_STATS.
> - Changed vf_ext param to bool.
> - Check if VF num exceeds the opened VFs range and return without
> adding the vfinfo.

If you repost something without addressing feedback you received you
_have_ _to_ describe what that feedback was and why it was ignored in 
the cover letter of the new posting, please and thank you.
