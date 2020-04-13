Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297111A6564
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 12:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgDMKtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 06:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728778AbgDMKtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 06:49:42 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2020 06:49:42 EDT
X-Greylist: delayed 301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Apr 2020 03:39:58 PDT
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B7DC0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 03:39:58 -0700 (PDT)
Received: from ramsan ([84.195.182.253])
        by laurent.telenet-ops.be with bizsmtp
        id SAaw220085USYZQ01Aawpr; Mon, 13 Apr 2020 12:34:56 +0200
Received: from geert (helo=localhost)
        by ramsan with local-esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jNwQa-00005I-1M; Mon, 13 Apr 2020 12:34:56 +0200
Date:   Mon, 13 Apr 2020 12:34:56 +0200 (CEST)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     linux-kernel@vger.kernel.org
cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: Build regressions/improvements in v5.7-rc1
In-Reply-To: <20200413093100.24470-1-geert@linux-m68k.org>
Message-ID: <alpine.DEB.2.21.2004131232220.32713@ramsan.of.borg>
References: <20200413093100.24470-1-geert@linux-m68k.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Apr 2020, Geert Uytterhoeven wrote:
> Below is the list of build error/warning regressions/improvements in
> v5.7-rc1[1] compared to v5.6[2].
>
> Summarized:
>  - build errors: +132/-3
>  - build warnings: +257/-79
>
> Happy fixing! ;-)
>
> Thanks to the linux-next team for providing the build service.
>
> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/8f3d9f354286745c751374f5f1fcafee6b3f3136/ (all 239 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/7111951b8d4973bda27ff663f2cf18b663d15b48/ (all 239 configs)
>
>
> *** ERRORS ***
>
> 132 error regressions:
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/hash.h: error: implicit declaration of function 'pte_raw' [-Werror=implicit-function-declaration]:  => 192:2
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/hash.h: error: implicit declaration of function 'pte_raw'; did you mean 'pte_read'? [-Werror=implicit-function-declaration]:  => 192:8
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/mmu-hash.h: error: 'SLICE_NUM_HIGH' undeclared here (not in a function):  => 698:2, 698:30
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/mmu-hash.h: error: 'struct mmu_psize_def' has no member named 'ap':  => 207:28
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/mmu-hash.h: error: 'struct mmu_psize_def' has no member named 'avpnm':  => 337:57
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/mmu-hash.h: error: 'struct mmu_psize_def' has no member named 'penc':  => 411:49
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/mmu-hash.h: error: 'struct mmu_psize_def' has no member named 'penc'; did you mean 'enc'?:  => 411:50
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/mmu-hash.h: error: 'struct mmu_psize_def' has no member named 'sllp':  => 218:32, 219:26
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/mmu-hash.h: error: redefinition of 'mmu_psize_to_shift':  => 195:28
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/mmu-hash.h: error: redefinition of 'shift_to_mmu_psize':  => 185:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable-4k.h: error: implicit declaration of function 'pgd_raw' [-Werror=implicit-function-declaration]:  => 35:3
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable-4k.h: error: implicit declaration of function 'pgd_raw'; did you mean 'pgd_val'? [-Werror=implicit-function-declaration]:  => 35:13
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable-4k.h: error: implicit declaration of function 'pud_raw' [-Werror=implicit-function-declaration]:  => 25:3
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable-4k.h: error: implicit declaration of function 'pud_raw'; did you mean 'pud_val'? [-Werror=implicit-function-declaration]:  => 25:13
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable-4k.h: error: redefinition of 'hugepd_ok':  => 44:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable-4k.h: error: redefinition of 'pgd_huge':  => 29:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable-4k.h: error: redefinition of 'pmd_huge':  => 9:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable-4k.h: error: redefinition of 'pud_huge':  => 19:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: expected ')' before '!=' token:  => 964:19, 921:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: expected ')' before '==' token:  => 979:19, 801:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: expected ')' before '^' token:  => 801:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: expected ')' before '__vmalloc_end':  => 291:21, 274:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: expected identifier or '(' before '!' token:  => 916:19, 904:19, 939:19, 959:19, 868:19, 873:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: expected identifier or '(' before 'struct':  => 291:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: implicit declaration of function '__pgd_raw' [-Werror=implicit-function-declaration]:  => 976:2
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: implicit declaration of function '__pgd_raw'; did you mean '__fdget_raw'? [-Werror=implicit-function-declaration]:  => 976:9
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: implicit declaration of function '__pmd_raw' [-Werror=implicit-function-declaration]:  => 1075:9, 1075:2
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: implicit declaration of function '__pte_raw' [-Werror=implicit-function-declaration]:  => 552:2, 552:9
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: implicit declaration of function '__pud_raw' [-Werror=implicit-function-declaration]:  => 935:9, 935:2
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: incompatible types when returning type 'int' but 'pgd_t' was expected:  => 976:2
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: incompatible types when returning type 'int' but 'pgd_t' {aka 'struct <anonymous>'} was expected:  => 976:9
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: incompatible types when returning type 'int' but 'pmd_t' was expected:  => 1075:2
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: incompatible types when returning type 'int' but 'pmd_t' {aka 'struct <anonymous>'} was expected:  => 1075:9
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: incompatible types when returning type 'int' but 'pte_t' was expected:  => 675:2, 552:2, 971:2, 670:2, 1070:2, 647:2, 652:2, 642:2, 695:2, 660:2, 632:2, 665:2, 690:2, 627:2, 714:2, 930:2, 685:2, 637:2
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: incompatible types when returning type 'int' but 'pte_t' {aka 'struct <anonymous>'} was expected:  => 1070:9, 695:9, 627:9, 685:9, 642:9, 930:9, 647:9, 690:9, 665:9, 660:9, 675:9, 670:9, 714:9, 552:9, 971:9, 637:9, 632:9, 652:9
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: incompatible types when returning type 'int' but 'pud_t' was expected:  => 935:2
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: incompatible types when returning type 'int' but 'pud_t' {aka 'struct <anonymous>'} was expected:  => 935:9
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of '__ptep_set_access_flags':  => 789:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of '__ptep_test_and_clear_young':  => 371:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of '__set_pte_at':  => 815:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'huge_ptep_set_wrprotect':  => 437:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pfn_pte':  => 609:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pgd_clear':  => 954:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pgd_is_leaf':  => 1373:21, 1375:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pgd_pte':  => 969:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pmd_clear':  => 863:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pmd_is_leaf':  => 1359:21, 1361:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pmd_pte':  => 1068:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_access_permitted':  => 587:20, 586:30
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_ci':  => 853:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_clear':  => 474:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_devmap':  => 704:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_dirty':  => 480:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_exec':  => 495:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_exprotect':  => 630:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_hw_valid':  => 567:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_mkclean':  => 635:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_mkdirty':  => 663:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_mkexec':  => 645:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_mkhuge':  => 678:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_mkold':  => 640:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_mkprivileged':  => 688:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_mkpte':  => 650:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_mkspecial':  => 673:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_mkuser':  => 693:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_mkwrite':  => 655:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_mkyoung':  => 668:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_modify':  => 711:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_none':  => 808:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_pfn':  => 617:29
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_pgd':  => 974:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_present':  => 556:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_pud':  => 933:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_read':  => 421:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_special':  => 490:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_unmap':  => 1022:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_update':  => 353:29
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_user':  => 581:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_write':  => 416:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_wrprotect':  => 623:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pte_young':  => 485:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'ptep_get_and_clear':  => 451:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'ptep_get_and_clear_full':  => 459:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'ptep_set_wrprotect':  => 427:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pud_clear':  => 911:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pud_is_leaf':  => 1366:21, 1368:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: redefinition of 'pud_pte':  => 928:21
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: static declaration of 'map_kernel_page' follows non-static declaration:  => 1037:19
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: static declaration of 'vmemmap_create_mapping' follows non-static declaration:  => 1049:29
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/pgtable.h: error: static declaration of 'vmemmap_remove_mapping' follows non-static declaration:  => 1059:20
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/radix.h: error: implicit declaration of function 'pmd_raw' [-Werror=implicit-function-declaration]:  => 221:2
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/radix.h: error: implicit declaration of function 'pmd_raw'; did you mean 'pmd_val'? [-Werror=implicit-function-declaration]:  => 221:11
>  + /kisskb/src/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h: error: 'struct mmu_psize_def' has no member named 'ap':  => 11:30
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: 'struct kvm_vcpu_arch' has no member named 'book3s':  => 316:19
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: 'struct kvm_vcpu_arch' has no member named 'fault_dar':  => 396:19
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: 'struct kvm_vcpu_arch' has no member named 'fault_dar'; did you mean 'fault_dear'?:  => 396:20
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_get_cr':  => 343:19
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_get_ctr':  => 363:21
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_get_fault_dar':  => 394:21
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_get_gpr':  => 333:21
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_get_lr':  => 373:21
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_get_pc':  => 383:21
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_get_xer':  => 353:21
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_need_byteswap':  => 389:20
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_set_cr':  => 338:20
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_set_ctr':  => 358:20
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_set_gpr':  => 328:20
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_set_lr':  => 368:20
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_set_pc':  => 378:20
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_set_xer':  => 348:20
>  + /kisskb/src/arch/powerpc/include/asm/kvm_book3s.h: error: redefinition of 'kvmppc_supports_magic_page':  => 405:20
>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable-4k.h: error: expected ')' before '!=' token:  => 58:40
>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable-4k.h: error: expected ')' before '==' token:  => 57:37
>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable-4k.h: error: expected identifier or '(' before '!' token:  => 56:25
>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable.h: error: expected ')' before '!=' token:  => 163:40
>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable.h: error: expected ')' before '==' token:  => 333:50
>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable.h: error: expected ')' before '^' token:  => 333:36
>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable.h: error: expected identifier or '(' before '!' token:  => 146:27, 144:24, 160:25, 161:24, 143:25
>  + /kisskb/src/arch/powerpc/include/asm/nohash/64/pgtable.h: error: expected identifier or '(' before 'struct':  => 77:21
>  + /kisskb/src/arch/powerpc/include/asm/nohash/pgtable.h: error: redefinition of 'pgd_huge':  => 291:19
>  + /kisskb/src/arch/powerpc/include/asm/nohash/pte-book3e.h: error: redefinition of 'pte_mkprivileged':  => 108:26
>  + /kisskb/src/arch/powerpc/include/asm/nohash/pte-book3e.h: error: redefinition of 'pte_mkuser':  => 115:20
>  + /kisskb/src/arch/powerpc/kvm/book3s_64_vio_hv.c: error: 'struct kvm_arch' has no member named 'spapr_tce_tables':  => 68:46, 68:2

ppc64_book3e_allmodconfig

>  + /kisskb/src/arch/sh/mm/init.c: error: control reaches end of non-void function [-Werror=return-type]:  => 424:1
>  + /kisskb/src/arch/sh/mm/init.c: error: expected ')' before 'return':  => 416:3
>  + /kisskb/src/arch/sh/mm/init.c: error: expected expression before '}' token:  => 424:1
>  + /kisskb/src/arch/sh/mm/init.c: error: unused variable 'nr_pages' [-Werror=unused-variable]:  => 412:16
>  + /kisskb/src/arch/sh/mm/init.c: error: unused variable 'ret' [-Werror=unused-variable]:  => 413:6
>  + /kisskb/src/arch/sh/mm/init.c: error: unused variable 'start_pfn' [-Werror=unused-variable]:  => 411:16

shx3_defconfig (fix available)

>  + /kisskb/src/drivers/vdpa/vdpa_sim/vdpa_sim.c: error: implicit declaration of function 'set_dma_ops' [-Werror=implicit-function-declaration]:  => 324:2

um-all{yes,mod}config
allmodconfig+64K_PAGES

>  + error: modpost: "__delay" [drivers/net/phy/mdio-cavium.ko] undefined!:  => N/A

sh-allmodconfig (seen before, __delay is an internal function, not to be
called by drivers, cfr. "Undefined functions to get compile-time errors")

>  + error: modpost: "sysrq_mask" [drivers/tty/serial/serial_core.ko] undefined!:  => N/A

pmac32_defconfig{,+SMP,+KVM} (fix available)

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
