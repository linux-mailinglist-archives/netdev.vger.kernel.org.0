Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE7E8C4F0
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 01:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfHMX7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 19:59:14 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:36818 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfHMX7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 19:59:14 -0400
Received: by mail-qk1-f170.google.com with SMTP id d23so6394771qko.3
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 16:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=puwKGvMHBRGGwnXpTzyxte5//PO1DQzRFyAR88F1LHM=;
        b=GfIUpV2WFfIt/TZJG9RCEnWkYQWE4g5TCogARMUD7cy5ZSagkbIfo7Dd3D/1DdT69M
         6UguVvy8mIpio/oCU4CpkFacBdyVe+rykoBW/imDUaE5hm3Z0Z+47cB7ob/pJHC4SOoj
         mOjY1fQdsfIZ9X2v2409xfU+DZ6RqIh+qD8MQnJRd/f+UwzQbwM+8OaHlEKcr+3OJ4a7
         sIpc9I5LtkH9g9o8j/yKPD1lHJdYCoB7VBHIAu2vO8WhHjNyIK+b/UimurjkRL9uF+rL
         S5w+2G8J29uu1W/yVn7c2UT+7pD2ak4tsZKXpUyYnQ2B4I8j2IQBol78m+0o9OArsRH2
         E41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=puwKGvMHBRGGwnXpTzyxte5//PO1DQzRFyAR88F1LHM=;
        b=mF8wEr9EvSI83n3E3dK0CKPhiVI61ltdhqbhoegmSBwI1WjDl8GS4ENeqHedhzlXQX
         rDb/DNgaz8nxIbqLBnY0FQcrrn6bVA1frlRHPj0XuBLanTOLGB1EbhHVU+pYq8UzfG5B
         4yY5iQBYxmxFVSKwZMBZOaIoKHLSHj7zP5CbOXyPLKe18RfWzBUfqTSr9fhQXSzhOmEI
         PLTixBOBY0RVXPZYiw+VZMDFlhjCwuCHvvsLEczR2adVNwiZa0GOjpG1wMCJUhLIDCM0
         3SSn+Te+wfDSvqUgLqLvsq65crKnQ7UrD4E3spMtNdMh8jL89pMdkgzwOYNairY55B+I
         /yXQ==
X-Gm-Message-State: APjAAAWaH7EVRUGpag4vGnlk/dzmcrk5fi5DrnElnHuD+kWWlABprqON
        /CfPkhzCY+6yv9+Xq/LNdbWF2w==
X-Google-Smtp-Source: APXvYqxNDfm93dGm8rKT57NcptHKGxkf0EPwpFoD7YNZ0cXT33fvXUY9sdVbitMxp6dCM5dgryvRhw==
X-Received: by 2002:a37:bac3:: with SMTP id k186mr12613qkf.61.1565740753019;
        Tue, 13 Aug 2019 16:59:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j184sm44248666qkc.65.2019.08.13.16.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 16:59:12 -0700 (PDT)
Date:   Tue, 13 Aug 2019 16:59:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2019-08-14
Message-ID: <20190813165902.41da0730@cakuba.netronome.com>
In-Reply-To: <20190813231639.29891-1-daniel@iogearbox.net>
References: <20190813231639.29891-1-daniel@iogearbox.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 01:16:39 +0200, Daniel Borkmann wrote:
> Hi David, hi Jakub,
>=20
> The following pull-request contains BPF updates for your *net-next* tree.

Pulled, let me know if I did it wrong =F0=9F=A4=9E
