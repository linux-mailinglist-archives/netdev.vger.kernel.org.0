Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E71136390
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 00:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgAIXDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 18:03:34 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39243 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgAIXDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 18:03:34 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so60879plp.6;
        Thu, 09 Jan 2020 15:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=yVY4gK57hnmK7Q2J8KFryRadxlBxV/Wa/QpNyN+IfM0=;
        b=PXpmXB69SITodoyiTXv48OBDv1otgtZDvDR00qtl5uyCvdoTWH1SS72/bOsdkW0QKJ
         9yFgqzpSWxYHA/f+DxZAfRv2NweDx/Fh0L/Hp2E9EgAUztLdUgVN5EhWfML177Zv7BJK
         DYKKvQo/rruXbyY6z9Ln5qA9IbZnzczNL0kZzYle9QXqRDnzvirvwrwGZ5zHs+EiVSyK
         VUnxP8DQP6DeUPeblLujGpLJz+wkaNvDY6jh2gb4jsCmAIF55oUpj/z7ZtzPVKFQdmPd
         vPA+MM2C88UIoisPItEXFfKpAeFDWInZuzcw3ptY2/BUwyDuFfCmMnswW51+E67One5Q
         vcBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=yVY4gK57hnmK7Q2J8KFryRadxlBxV/Wa/QpNyN+IfM0=;
        b=bnZ33Bjf4OJlDg61QXQaACr67WCrzEBIHJDvtHaH1E1H+ZgOxBnpS4sM2bhgmv+ePU
         XWSW39vfR8do8QriXk0RfCHz2JOn8uEtNGUM14MYwvS2P+Krk14ggnPz5HHyqxlQUJWo
         39jgN8v+PunLXzG+vAF6lJfVYHI0h5Rf2pYX7tl+b3yH8dnpBU9Fvon3i5fnNaRKBRGd
         QhzOrnNA1SPEGQuyEvQJtQRYHNg3nKwKhVDNSmEsE1AccJkacIseXpIllW3JTvJUWz9e
         t+HB2OaZ/fXtNGCVHgZnfSi/EaKESMLKCy63fCrG5WKr22IjCbgLvLAR7/3/JuaUkCZd
         ep1Q==
X-Gm-Message-State: APjAAAVPiNbjeEXFzeLl1L0nqa05Zzfnei3LCCKwQoE8OzPRnpQgR2TO
        FvEQvqaLuzewAeJK60arsRo=
X-Google-Smtp-Source: APXvYqzXctqXplHUOGVwkejnFSg9l/WyAzdpu96aK429iO6peZxP0EOt1RnK2OlbjLsgprJGx9BALA==
X-Received: by 2002:a17:902:59c9:: with SMTP id d9mr445980plj.184.1578611013433;
        Thu, 09 Jan 2020 15:03:33 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::3:d3c9])
        by smtp.gmail.com with ESMTPSA id s26sm76505pfe.166.2020.01.09.15.03.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2020 15:03:32 -0800 (PST)
Date:   Thu, 9 Jan 2020 15:03:31 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/6] bpf: Introduce function-by-function
 verification
Message-ID: <20200109230328.i6zuva5gqezpltwp@ast-mbp>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-4-ast@kernel.org>
 <87y2uigs3e.fsf@toke.dk>
 <20200108200655.vfjqa7pq65f7evkq@ast-mbp>
 <87ftgpgg6p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ftgpgg6p.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 09:57:50AM +0100, Toke Høiland-Jørgensen wrote:
> 
> > As far as future plans when libbpf sees FUNC_EXTERN it will do the linking the
> > way we discussed in the other thread. The kernel will support FUNC_EXTERN when
> > we introduce dynamic libraries. A collection of bpf functions will be loaded
> > into the kernel first (like libc.so) and later programs will have FUNC_EXTERN
> > as part of their BTF to be resolved while loading. The func name to btf_id
> > resolution will be done by libbpf. The kernel verifier will do the type
> > checking on BTFs.
> 
> Right, FUNC_EXTERN will be rejected by the kernel unless it's patched up
> with "target" btf_ids by libbpf before load? So it'll be
> FUNC_GLOBAL-linked functions that will be replaceable after the fact
> with the "dynamic re-linking" feature?

Right. When libbpf statically links two .o it will need to produce a combined
BTF out of these two .o. That new BTF will not have FUNC_EXTERN anymore if they
are resolved. When the kernel sees FUNC_EXTERN it's a directive for the kernel
to resolve it. BPF program with FUNC_EXTERN references would be loadable, but
not executable. Anyhow the extern work is not immediate. I don't think any of
that is necessary for dynamic re-linking.
