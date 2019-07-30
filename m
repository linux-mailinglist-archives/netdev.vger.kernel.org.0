Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475F67B462
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbfG3UkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:40:07 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36692 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbfG3UkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 16:40:07 -0400
Received: by mail-pl1-f196.google.com with SMTP id k8so29365470plt.3
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 13:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=j2gv1qsT5nXBd1CmzQr/bGdJVB+E6H0tG5YhMqsyxuQ=;
        b=0y926QFI5DC/KvASHMpnW8ZID49e8+LIpOzx31BrM7ThQaaqb58PvSF2ZGTTSyPoFx
         Wl+rzNyvWk8VYZ9hZkS8CoLBs0JV1hUNyl3EhSlRTVrZ8m6Nzt5ht+1nXAW6EN3rE7ZB
         PjiIcEWZSsHxEjZ3lWp7hYMICtKzMd0BmsTWWfB4MDqoV5DmQLarrTAnZuxWq4zEivBA
         yw8+jcJpafKwAhJfGQmvFJIxHZPrky9cqZ1hhBrQzmIOGS2UmHkPyf5ivAxZTF7J1FQZ
         4N/fzvYYjA7xmjC/XmNwBiXSvd5ZZ5M3/5eYDMYvtYLvkfGHPDcHsuwwNM0DLkugJyvx
         yNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=j2gv1qsT5nXBd1CmzQr/bGdJVB+E6H0tG5YhMqsyxuQ=;
        b=R76q9cJfYcYjLn8wLM7LIg5UTTjtZ0xMqY6g4vRIN4U9EkJtUtc2qHuocgJqQyQl+v
         GUDQxtJXnJCTqDfRVJwTtmqReXnCMPvO3pZpEoklwCKJR9/5Bt3LA7YuAa2d71E6UWyr
         +IC6ZQlaC3DHetZBEuKrv3/w1YyL0DcnWAZjLKnk+HGCcuapgMDZS9HPiF2CdaYlAkuE
         EYp+bB6JjXwkXP71mehc9LtRj+Fwx5rhNo53gpxhsmKr2SVI/lFz5IPFPvVw2e2nRD8k
         rC0a11ueX4czs/pM8b6EKzxrZUi82gru91ohGpp6d4R7uWgCryOKjucO0OXTJOnUBtag
         SoUw==
X-Gm-Message-State: APjAAAVB76AlVYK8kqeVEEn2ZwnYnVz8oUyahgq6nYZB072kGOFAwXeh
        W2dfnZG9DlUvOvpNklwTpxGqgw==
X-Google-Smtp-Source: APXvYqyBqFW4sP357vf4AGepdDriQB2/bLlzaAHREt3sqTsbOWg0GP3BsTou+3D5Gy6GgZf/xlWhOQ==
X-Received: by 2002:a17:902:5a2:: with SMTP id f31mr114651047plf.72.1564519206693;
        Tue, 30 Jul 2019 13:40:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u7sm59495517pgr.94.2019.07.30.13.40.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 13:40:06 -0700 (PDT)
Date:   Tue, 30 Jul 2019 13:39:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <willy@infradead.org>, <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/3 net-next] Finish conversion of skb_frag_t to
 bio_vec
Message-ID: <20190730133949.7339bfcb@cakuba.netronome.com>
In-Reply-To: <20190730144034.444022-1-jonathan.lemon@gmail.com>
References: <20190730144034.444022-1-jonathan.lemon@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 07:40:31 -0700, Jonathan Lemon wrote:
> The recent conversion of skb_frag_t to bio_vec did not include
> skb_frag's page_offset.  Add accessor functions for this field,
> utilize them, and remove the union, restoring the original structure.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
