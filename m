Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03686184F9D
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 20:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgCMTwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 15:52:12 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36762 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgCMTwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 15:52:10 -0400
Received: by mail-lf1-f68.google.com with SMTP id s1so8867025lfd.3;
        Fri, 13 Mar 2020 12:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jIzR2VF5pztT8bGJoCnv210VBMIFx941tvF4lgwyJhk=;
        b=H/4G0a4inqFmyc/ZgU9YotdnJII5m3EQDJJrxGps6EtV0QFXrC//vl5+03L3cOHdGy
         rMuPqzftPUB77oaFRc0jdyTu0Yd6DIIQSwMTTRG/sHMUExTW8d1AayCkiDJJQG10AnNu
         wF51wj5tDrEa/x/K4FUtkoVv7DcbniTMXF8sWXczVij4/XuwPKHrgdF/Dsuj3PyShFF8
         JlyZvWRVMrR+UgaSu/cQLLQTUZ0gyWV/trt4RNPtAcBWFKC1fRpRh6qJlYAIB2iiHe7x
         S7sAQ+KVKb6x3q9rQahoc4H/t+Vfyzt/KUe9t3Hd9nhA2g22AnR9lR6X+FdWPH39Wlfr
         QVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jIzR2VF5pztT8bGJoCnv210VBMIFx941tvF4lgwyJhk=;
        b=BihbkNG7oQ9vxR4qDFz2nU8scLKdMEWWqYyJDLbga6k6uWXJfxqllEF6wURbwSOMs6
         BvH2QO8RF3/Xo6KxRKSBLxdhVFIbElQoxb1hgTfjm1XqrVAN3afxpjDO8nBPrC7p+G7n
         qqyIGL5XZFVJU01FcQ8llbOjTuNVhgz88oQKNAcLffB0I+jZLbDM+XznR/G+Q8XEUE6n
         2/ZdRLZSxWSIf0jGippVRVJOVfMCES+Bvc21AnrLg1LIxvRq9zgByIpk0vOlEaBAdT2V
         YaL9+WxG2w0fX42LErzKxWVIJEN8Zh/kY5pzwyi/ANcI+FdvQ2l9ma+CIIBjuAJ5/rME
         nC6g==
X-Gm-Message-State: ANhLgQ3eg2Yh4rJxL7q6Eo4+311fSzEpBLSOFqP9rcilEDNIaNx9dGy+
        G+BboGZAYDO7IUWIv3sDkqmdOoyO/TOHOqtsyg8=
X-Google-Smtp-Source: ADFU+vuyob2kNVFX2qwNK4cHEIyyfQOOrYJ9edLrWt/ZgCK5EyTlrU/7fRLKklUBicSDGHyC6BLUkY/zy7R10T1EXd0=
X-Received: by 2002:a19:a401:: with SMTP id q1mr9255620lfc.157.1584129126306;
 Fri, 13 Mar 2020 12:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200313135850.2329f480@canb.auug.org.au>
In-Reply-To: <20200313135850.2329f480@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 13 Mar 2020 12:51:54 -0700
Message-ID: <CAADnVQ+r3hMEtqbkhm1j9HyXYxSNihbX=VCR9erUGXoE72Pwsg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the jc_docs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Kitt <steve@sk2.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 7:59 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the bpf-next tree got a conflict in:
>
>   Documentation/admin-guide/sysctl/kernel.rst
>
> between commit:
>
>   a3cb66a50852 ("docs: pretty up sysctl/kernel.rst")
>
> from the jc_docs tree and commit:
>
>   c480a3b79cbc ("docs: sysctl/kernel: Document BPF entries")
>
> from the bpf-next tree.

I dropped this commit from bpf-next, since it causes unnecessary conflicts.
Please steer it via Jon's tree.
Thanks
