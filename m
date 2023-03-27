Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEE96CA25F
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 13:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjC0L2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 07:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjC0L2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 07:28:01 -0400
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3948B8;
        Mon, 27 Mar 2023 04:27:58 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4PlVgX39kFz9xFQR;
        Mon, 27 Mar 2023 19:18:48 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwAn9FqWfSFk7BTRAQ--.62311S2;
        Mon, 27 Mar 2023 12:27:33 +0100 (CET)
Message-ID: <bfe6ba6a3953f2f66ed040a8096c4dd5e2724b95.camel@huaweicloud.com>
Subject: Re: [PATCH 0/5] usermode_driver: Add management library and API
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Date:   Mon, 27 Mar 2023 13:27:15 +0200
In-Reply-To: <CAADnVQJv0qWaxRD2_tmXeR9Wf=zdnvk8SwztOAorGaer0dFv3w@mail.gmail.com>
References: <20230317145240.363908-1-roberto.sassu@huaweicloud.com>
         <CAADnVQLKONwKwkJMopRq-dzcV2ZejrjGzyuzW_5QX=0BY=Z4jw@mail.gmail.com>
         <b5c80613c696818ce89b92dac54e98878ec3ccd0.camel@huaweicloud.com>
         <CAADnVQJC0h7rtuntt0tqS5BbxWsmyWs3ZSbboZMmUKetMG2VhA@mail.gmail.com>
         <e0b828d994a8427ad48b7b514f75d751ea791b47.camel@huaweicloud.com>
         <CAADnVQJv0qWaxRD2_tmXeR9Wf=zdnvk8SwztOAorGaer0dFv3w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwAn9FqWfSFk7BTRAQ--.62311S2
X-Coremail-Antispam: 1UD129KBjvJXoW3ArWUCryDCw47JrWDXr15twb_yoW3GFW3pF
        WrGF4jka1DJr13Arn2vw18Ca409397tw45WrnxJryfAwn09F1xKr12kF1a9F1DGr1fKw1Y
        vr4Uta42g3Z8ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFYFCUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAJBF1jj4c1XAAAsQ
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-03-24 at 19:54 -0700, Alexei Starovoitov wrote:
> On Thu, Mar 23, 2023 at 6:37 AM Roberto Sassu
> <roberto.sassu@huaweicloud.com> wrote:
> > On Wed, 2023-03-22 at 15:27 -0700, Alexei Starovoitov wrote:
> > > On Wed, Mar 22, 2023 at 5:08 AM Roberto Sassu
> > > <roberto.sassu@huaweicloud.com> wrote:
> > > > On Tue, 2023-03-21 at 19:23 -0700, Alexei Starovoitov wrote:
> > > > > On Fri, Mar 17, 2023 at 7:53 AM Roberto Sassu
> > > > > <roberto.sassu@huaweicloud.com> wrote:
> > > > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > > 
> > > > > > A User Mode Driver (UMD) is a specialization of a User Mode Helper (UMH),
> > > > > > which runs a user space process from a binary blob, and creates a
> > > > > > bidirectional pipe, so that the kernel can make a request to that process,
> > > > > > and the latter provides its response. It is currently used by bpfilter,
> > > > > > although it does not seem to do any useful work.
> > > > > 
> > > > > FYI the new home for bpfilter is here:
> > > > > https://github.com/facebook/bpfilter
> > > > 
> > > > Thanks. I just ensured that it worked, by doing:
> > > > 
> > > > getsockopt(fd, SOL_IP, IPT_SO_GET_INFO, &info, &optlen);
> > > > 
> > > > and accepting IPT_SO_GET_INFO in main.c.
> > > > 
> > > > > > The problem is, if other users would like to implement a UMD similar to
> > > > > > bpfilter, they would have to duplicate the code. Instead, make an UMD
> > > > > > management library and API from the existing bpfilter and sockopt code,
> > > > > > and move it to common kernel code.
> > > > > > 
> > > > > > Also, define the software architecture and the main components of the
> > > > > > library: the UMD Manager, running in the kernel, acting as the frontend
> > > > > > interface to any user or kernel-originated request; the UMD Loader, also
> > > > > > running in the kernel, responsible to load the UMD Handler; the UMD
> > > > > > Handler, running in user space, responsible to handle requests from the UMD
> > > > > > Manager and to send to it the response.
> > > > > 
> > > > > That doesn't look like a generic interface for UMD.
> > > > 
> > > > What would make it more generic? I made the API message format-
> > > > independent. It has the capability of starting the user space process
> > > > as required, when there is a communication.
> > > > 
> > > > > It was a quick hack to get bpfilter off the ground, but certainly
> > > > > not a generic one.
> > > > 
> > > > True, it is not generic in the sense that it can accomodate any
> > > > possible use case. The main goal is to move something that was running
> > > > in the kernel to user space, with the same isolation guarantees as if
> > > > the code was executed in the kernel.
> > > 
> > > They are not the same guarantees.
> > > UMD is exactly equivalent to root process running in user space.
> > > Meaning it can be killed, ptraced, priority inverted, etc
> > 
> > That is the starting point.
> > 
> > I suppose you can remove any privilege from the UMD process, it just
> > needs to read/write from/to a pipe (and in my case to use socket() with
> > AF_ALG to interact with the Crypto API).
> > 
> > Also, as I mentioned, you can enforce a very strict seccomp profile,
> > which forces the UMD process to use a very limited number of system
> > calls.
> > 
> > For the interactions of the rest of the system to the UMD process, you
> > could deny with an LSM all the operations that you mentioned. The rest
> > of the system would not be affected, only operations which have the UMD
> > process as target are denied.
> > 
> > > > > > I have two use cases, but for sake of brevity I will propose one.
> > > > > > 
> > > > > > I would like to add support for PGP keys and signatures in the kernel, so
> > > > > > that I can extend secure boot to applications, and allow/deny code
> > > > > > execution based on the signed file digests included in RPM headers.
> > > > > > 
> > > > > > While I proposed a patch set a while ago (based on a previous work of David
> > > > > > Howells), the main objection was that the PGP packet parser should not run
> > > > > > in the kernel.
> > > > > > 
> > > > > > That makes a perfect example for using a UMD. If the PGP parser is moved to
> > > > > > user space (UMD Handler), and the kernel (UMD Manager) just instantiates
> > > > > > the key and verifies the signature on already parsed data, this would
> > > > > > address the concern.
> > > > > 
> > > > > I don't think PGP parser belongs to UMD either.
> > > > > Please do it as a normal user space process and define a proper
> > > > > protocol for communication between kernel and user space.
> > > > 
> > > > UMD is better in the sense that it establishes a bidirectional pipe
> > > > between the kernel and the user space process. With that, there is no
> > > > need to further restrict the access to a sysfs file, for example.
> > > 
> > > If a simple pipe is good enough then you can have a kernel module
> > > that creates it and interacts with the user space process.
> > 
> > Few points I forgot to mention.
> > 
> > With the UMD approach, the binary blob is embedded in the kernel
> > module, which means that no external dependencies are needed for
> > integrity verification. The binary is statically compiled, and the
> > kernel write-protects it at run-time.
> > 
> > Second, since DIGLIM would check the integrity of any executable,
> > including init, the PGP signature verification needs to occur before.
> > So, the PGP UMD should be already started by then. That is not going to
> > be a problem, since the binary is copied to a private tmpfs mount.
> > 
> > > Out-of-tree bpftiler can do that, so can you.
> > 
> > As far as I can see, the out-of-tree bpfilter works exactly in the same
> > way as the in-tree counterpart. The binary blob is embedded in the
> > kernel module.
> > 
> > > PGP is not suitable for kernel git repo either as kernel code or as UMD.
> > 
> > Well, the asymmetric key type can be extended with new parsers, so this
> > possibility was already taken into account. The objection that the PGP
> > parser should not run in kernel space is fair, but I think the UMD
> > approach fully addresses that.
> > 
> > Also, I agree with you that we should not just take any code and
> > pretend that it is part of the kernel. However, in this particular
> > case, the purpose of the PGP UMD would be simply to extract very few
> > information from the PGP packets. The asymmetric key type and the
> > signature verification infrastructure already take care of the rest.
> > 
> > PGP keys and signatures would act as an additional system trust anchor
> > for verifying critical system data (for DIGLIM, which executables are
> > allowed to run), similarly to how X.509 certificates are used for
> > verifying kernel modules. RPM headers, executables digests are taken
> > from, are signed with PGP, so there is no other way than adding this
> > functionality.
> > 
> > And unfortunately, especially for features impacting the entire system,
> > out-of-tree drivers are not really an option:
> 
> I think you have to start out of tree and prove that the PGP thing
> is worth considering at all.
> Only then we can talk about merits of UMD and generalization
> of pipe interface if it's applicable.

Ok. This is my plan:

1) send the kernel part necessary to support PGP keys and signatures
2) evaluate/discuss if something else can be moved to user space
3) propose the implementation of the PGP UMD
4) assess the robustness of the solution, and compare to different
   designs

Thanks

Roberto

> DIGLIM and everything else you mentioned above doesn't add weight
> to the decision. PGP work should be acceptable on its own.
> Out-of-tree is a method to prove that it works and later argue
> for inclusion as in-tree either as kernel module or UMD.
> Generalization of current bpfilter is out of scope here.

