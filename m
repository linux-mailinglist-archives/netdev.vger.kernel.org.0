Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEB9184E8B
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgCMSX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:23:29 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45515 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgCMSX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:23:28 -0400
Received: by mail-qt1-f195.google.com with SMTP id z8so4975024qto.12;
        Fri, 13 Mar 2020 11:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JEIIgjyB6rWxiG5f1Y72uJLPk0KOENTJH6GO0rKfix4=;
        b=JEDxRXUI9RKh3fEaHHJwACSYkbHQSxSK3DFjijVngVf0Cel/8RDLSQZKXi4hE8uwEZ
         /dXrEnGwN7gG17cFowiVXDA8cmv21FVPBc79+3MFQtMbIkEIEmrCZL4EvJV4ftyMebZS
         b9Y9lg2I5byFQxulwCz57ept9RhZuVkShzAwdSREQXbnyuCFviBKmnXN+AvEHtHHwzRc
         2PbpZInJhwVh9LN++tnDvQ+3Paon7PPIn+O//zgzJX4GqD22NhSX7WOocRWKB7POOlYj
         msItE/7h1SuBj/Ymz39rT1XzrE0zXlH2aslbGXqL9TF1krb4Unze5OTbwqjshONM0s/e
         DXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JEIIgjyB6rWxiG5f1Y72uJLPk0KOENTJH6GO0rKfix4=;
        b=jx1FYWVFdCHUNzmfLyeovZK6MOiSXIqy6KtnAEMHn+yfUZmP7UbBuGVTl/YGuUseSE
         BvYcTtvHzIyPg8mBdS95D4DU6tOwlyb6pdiZ4HDdCCwNKe1fE/cjVK/F1aIC3lkGaNqw
         EKmsCoFXSY0MonUMepVz/y6VKafwcuvAhDPHLs6XZbVbf+DPP0hTA15j8zpFAE/8QAGx
         7U7EzElehHr74XkAGngmcCS6XF9O5sRxNVbxCG7l96SLtTjk2g7Kz2xFSPKB4jKE9pV+
         srY2z/9C20ICmDNW3BRi9EfRxsRM+NFijsp93Ie7IF7TAQ1v7CZCE+KXYtIA2HjSc8O6
         aHMQ==
X-Gm-Message-State: ANhLgQ3CuPd0UL7pSStqjqd50z1OfUz9t2Nn0DiQCYiJuDdxn83h02ca
        AWrcbdcLMS5giTk1hGN6wdk=
X-Google-Smtp-Source: ADFU+vsgVFqdFe0DbOgJYswuauF9F6pjVyEkZyVzFN6eYKB43gdLd9yZEZyvqyuhsDZs0jdOkVj4KQ==
X-Received: by 2002:ac8:4784:: with SMTP id k4mr5663917qtq.78.1584123805731;
        Fri, 13 Mar 2020 11:23:25 -0700 (PDT)
Received: from bpf-dev (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.gmail.com with ESMTPSA id 10sm9551602qtt.65.2020.03.13.11.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 11:23:25 -0700 (PDT)
Date:   Fri, 13 Mar 2020 15:23:21 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, yhs@fb.com, quentin@isovalent.com,
        ebiederm@xmission.com, brouer@redhat.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf_helpers_doc.py: Fix warning when compiling
 bpftool.
Message-ID: <20200313182319.GA13630@bpf-dev>
References: <20200313154650.13366-1-cneirabustos@gmail.com>
 <20200313172119.3vflwxlbikvqdcqh@kafai-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313172119.3vflwxlbikvqdcqh@kafai-mbp>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 10:21:19AM -0700, Martin KaFai Lau wrote:
> On Fri, Mar 13, 2020 at 12:46:50PM -0300, Carlos Neira wrote:
> > 
> > When compiling bpftool the following warning is found: 
> > "declaration of 'struct bpf_pidns_info' will not be visible outside of this function."
> > This patch adds struct bpf_pidns_info to type_fwds array to fix this.
> > 
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> Fixes: b4490c5c4e02 ("bpf: Added new helper bpf_get_ns_current_pid_tgid")
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> 
> Please add the Fixes tag next time.  Other than tracking,
> it will be easier for review purpose also.

Thanks, I will do that in the future.

Bests
