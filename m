Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 716543525C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfFDVzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:55:39 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38073 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfFDVzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:55:39 -0400
Received: by mail-qk1-f196.google.com with SMTP id a27so3897394qkk.5
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QuQtFtk34Azd7891Fc4iDw2uTV/2EPAFdVwzXutl5lw=;
        b=ljGUfVFtRDtXiqd3JeQ2+dwGjQ9Tbd7+FqDhJuQvyS0erW8W7oPxubUy2FJUiOdQtz
         2vKlh4frf5gayyYN1dRaAgO7MRXmYjRkfkehPrk+MQoiLrQLZSmwTO0nTQ4v1epw8x9L
         nXJ0yDr2aiRbMphtHAdLFAKf7v90VRRaeqbbWkqi9iDuddY3aB+JCUDSq2mI386tlRAr
         3j1bKH1+IsZW9beanAzRztjj3fA4TMLoOjiaZwqoWM9lUymxiu5v0YPH4+J7/PiZKGtm
         oWZXX4XJRIoVhcynDTnIUaHpppLtSTaRSF43bOFTCgziIheT7Pu738w2YeGxJljQWIqv
         Cdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QuQtFtk34Azd7891Fc4iDw2uTV/2EPAFdVwzXutl5lw=;
        b=d0r0j5Hrz/LY/7SlxiE8BIomRWHOXXm41Qzy0J1B4nlk9Uu2iWe4TZJdF05wwEf4QT
         P0yLS5+L2PrsHi6dDTfJkYAaPFh5BcRZHxoCp6HjGv1jAVEf27ekcFOVvkNwBY81i6zr
         JspjiAP0MfmHZu9z37tKdG+VQsloUm4y/oGb5WJ0toe1nwC96PsYy95avusx2sAyxCx+
         khI+K/qiBW83EZvrb0Wc9SrcLv56XhYa3GFszoNTuBi3yit5a+mq4knywhAqtxjgaoqo
         KuKNQq8+9rouVid9FZlHxLEeVHjqkALw8UFpPWpb14lxPkSYQTMNwf39RQens+DqepQN
         FqqQ==
X-Gm-Message-State: APjAAAX5lpTiiTaMXLapWacLhDVGO3z4MKi3zLWojvkh2S9r5Ag35gcV
        Z+agBpG8w+FkLt/QChFmlkF0/g==
X-Google-Smtp-Source: APXvYqxvoKfqBBSgBMJMySc9IAfRGlrOI23txvOI+o4Fzeb9FtjfMMxUp5ZTiVH929G/zTnAUhErrw==
X-Received: by 2002:a37:dcc4:: with SMTP id v187mr29233382qki.290.1559685338165;
        Tue, 04 Jun 2019 14:55:38 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o6sm11869989qtc.47.2019.06.04.14.55.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 14:55:37 -0700 (PDT)
Date:   Tue, 4 Jun 2019 14:55:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH bpf-next 7/7] bpftool: support cgroup sockopt
Message-ID: <20190604145508.1364ddf8@cakuba.netronome.com>
In-Reply-To: <20190604213524.76347-8-sdf@google.com>
References: <20190604213524.76347-1-sdf@google.com>
        <20190604213524.76347-8-sdf@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Jun 2019 14:35:24 -0700, Stanislav Fomichev wrote:
> Support sockopt prog type and cgroup hooks in the bpftool.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
